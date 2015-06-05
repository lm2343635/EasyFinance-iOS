//
//  TallyListTableViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/23.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "RecordListTableViewController.h"
#import "RecordViewController.h"
#import "DaoManager.h"
#import "DateTool.h"
#import "RecordMonthlyStatisticalData.h"
#import "MJRefresh.h"

@interface RecordListTableViewController ()

@end

@implementation RecordListTableViewController {
    DaoManager *dao;
    User *loginedUser;
    //要显示数据的那一年的其中一个日期
    NSDate *yearDate;
    //按月分类的统计数据
    NSArray *monthlyStatisticalDatas;
    NSArray *records;
    Record *selectedRecord;
    //要显示的月份详细信息的索引值
    int showMonthIndex;
    //进度条最大值
    double progressMaxValue;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    loginedUser=[dao.userDao getLoginedUser];
    //设置TabBar选中文字的颜色
    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:TintColorRed
                                                                      green:TintColorGreen
                                                                       blue:TintColorBlue
                                                                      alpha:TintColorAlpha];
    //默认显示今年的数据
    yearDate=[NSDate date];
    //默认显示第一个月的详细视图
    showMonthIndex=0;
    //去掉表格分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置下拉加载上一年的数据
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadListOfLastYear)];
    [self.tableView.header setTitle:@"Load record list of last year" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"Release to load" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"Loading ..." forState:MJRefreshHeaderStateRefreshing];
    self.tableView.header.updatedTimeHidden = YES;
    //设置上拉加载下一年的数据
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadListOfNextYear)];
    [self.tableView.footer setTitle:@"Drag up to load record list of last year" forState:MJRefreshFooterStateIdle];
    [self.tableView.footer setTitle:@"Loading ..." forState:MJRefreshFooterStateRefreshing];
    [self.tableView.footer setTitle:@"No more data" forState:MJRefreshFooterStateNoMoreData];
}

-(void)viewDidAppear:(BOOL)animated {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self setDataByYear];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if([segue.identifier isEqualToString:@"recordSegue"]) {
        RecordViewController *controller=(RecordViewController *)[segue destinationViewController];
        controller.record=selectedRecord;
    }

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return monthlyStatisticalDatas.count+records.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UITableViewCell *cell=nil;
    //显示详细信息单元格
    if(showMonthIndex<indexPath.row&&indexPath.row<=showMonthIndex+records.count) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"recordCell"
                                             forIndexPath:indexPath];
        Record *record=[records objectAtIndex:indexPath.row-showMonthIndex-1];
        UILabel *dayLabel=(UILabel *)[cell viewWithTag:1];
        UIImageView *classificationIconImageView=(UIImageView *)[cell viewWithTag:2];
        UILabel *classificationNameLabel=(UILabel *)[cell viewWithTag:9];
        UILabel *moneyLabel=(UILabel *)[cell viewWithTag:4];
        UILabel *informationLabel=(UILabel *)[cell viewWithTag:8];
        dayLabel.text=[DateTool formateDate:record.time
                                 withFormat:DateFormatDay];
        classificationIconImageView.image=[UIImage imageWithData:record.classification.cicon.idata];
        classificationNameLabel.text=record.classification.cname;
        informationLabel.text=[NSString stringWithFormat:@"%@ | %@",record.account.aname,record.shop.sname];
        moneyLabel.text=[NSString stringWithFormat:@"%@",record.money];
        if([record.money doubleValue]<0)
            moneyLabel.textColor=[UIColor redColor];
    }else{  //显示月份统计单元格
        cell=[tableView dequeueReusableCellWithIdentifier:@"monthCell"
                                             forIndexPath:indexPath];
        NSUInteger dataIndex=indexPath.row;
        if(indexPath.row>showMonthIndex+records.count)
            dataIndex-=records.count;
        RecordMonthlyStatisticalData *data=[monthlyStatisticalDatas objectAtIndex:dataIndex];
        UILabel *monthLabel=(UILabel *)[cell viewWithTag:1];
        UILabel *monthDurationLabel=(UILabel *)[cell viewWithTag:2];
        UILabel *earnLabel=(UILabel *)[cell viewWithTag:3];
        UILabel *spendLabel=(UILabel *)[cell viewWithTag:4];
        UILabel *surplusLabel=(UILabel *)[cell viewWithTag:5];
        UIProgressView *earnProgressView=(UIProgressView *)[cell viewWithTag:6];
        UIProgressView *spendProgressView=(UIProgressView *)[cell viewWithTag:7];
        UIProgressView *surplusProgressView=(UIProgressView *)[cell viewWithTag:8];
        monthLabel.text=[DateTool formateDate:data.date withFormat:DateFormatLocalMonth];
        NSDateComponents *components=[DateTool getDateComponents:[DateTool getThisMonthEnd:data.date]];
        int days=(int)components.day;
        int month=(int)components.month;
        monthDurationLabel.text=[NSString stringWithFormat:@"%d.01~%d.%d",month,month,days];
        earnLabel.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:data.earn]];
        spendLabel.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:data.spend]];
        surplusLabel.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:data.earn-data.spend]];
        earnProgressView.progress=1-data.earn/progressMaxValue;
        spendProgressView.progress=1-data.spend/progressMaxValue;
        surplusProgressView.progress=1-fabs(data.earn-data.spend)/progressMaxValue;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //处理详细信息单元格点击事件
    if(showMonthIndex<indexPath.row&&indexPath.row<=showMonthIndex+records.count) {
        selectedRecord=[records objectAtIndex:indexPath.row-showMonthIndex-1];
        [self performSegueWithIdentifier:@"recordSegue" sender:self];
    }else{  //处理月份统计单元格点击事件
        NSUInteger dataIndex=indexPath.row;
        if(indexPath.row>showMonthIndex+records.count)
            dataIndex-=records.count;
        //当当前月份的详细信息被展开时，就关闭
        if(dataIndex==showMonthIndex&&records!=nil)
            records=nil;
        else {
            //设置当前要显示的详细信息的单元格为点击的月份统计单元格对应月份的收支记录
            showMonthIndex=(int)dataIndex;
            RecordMonthlyStatisticalData *data =[monthlyStatisticalDatas objectAtIndex:dataIndex];
            records=[dao.recordDao findByAccountBook:loginedUser.usingAccountBook
                                                from:[DateTool getThisMonthStart:data.date]
                                                  to:[DateTool getThisMonthEnd:data.date]];
        }
        [self.tableView reloadData];
    }
}


#pragma mark Service
//根据年份决定要显示的数据
-(void)setDataByYear {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    self.navigationItem.title=[NSString stringWithFormat:@"%@ in %@",RecordListNavigationTitle,
                               [DateTool formateDate:yearDate withFormat:DateFormatYear]];
    monthlyStatisticalDatas=[dao.recordDao getMonthlyStatisticalDataFrom:[DateTool getThisYearStart:yearDate]
                                                                      to:[DateTool getThisYearEnd:yearDate]
                                                           inAccountBook:loginedUser.usingAccountBook];
    if(monthlyStatisticalDatas.count>0) {
        //进度条最大值默认值为0
        progressMaxValue=0;
        for(RecordMonthlyStatisticalData *data in monthlyStatisticalDatas) {
            if(data.earn>progressMaxValue)
                progressMaxValue=data.earn;
            if(data.spend>progressMaxValue)
                progressMaxValue=data.spend;
            if(fabs(data.earn-data.spend)>progressMaxValue)
                progressMaxValue=fabs(data.earn-data.spend);
        }
        RecordMonthlyStatisticalData *data =[monthlyStatisticalDatas objectAtIndex:0];
        records=[dao.recordDao findByAccountBook:loginedUser.usingAccountBook
                                            from:[DateTool getThisMonthStart:data.date]
                                              to:[DateTool getThisMonthEnd:data.date]];
    }else{
        records=nil;
    }
    [self.tableView reloadData];
}

//加载上一年的数据
-(void)loadListOfLastYear {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    yearDate=[DateTool getADayOfLastYear:yearDate];
    [self setDataByYear];
    [self.tableView.header endRefreshing];
}

//加载下一年的数据
-(void)loadListOfNextYear {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    yearDate=[DateTool getADayOfNextYear:yearDate];
    [self setDataByYear];
    [self.tableView.footer endRefreshing];
}
@end
