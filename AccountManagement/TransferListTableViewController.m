//
//  TransferListTableViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/24.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "TransferListTableViewController.h"
#import "TransferViewController.h"
#import "DaoManager.h"
#import "DateTool.h"
#import "TransferMonthlyStatisticalData.h"
#import <MJRefresh/MJRefresh.h>

@interface TransferListTableViewController ()

@end

@implementation TransferListTableViewController {
    DaoManager *dao;
    User *loginedUser;
    //要显示数据的那一年的其中一个日期
    NSDate *yearDate;
    NSArray *monthlyStatisticalDatas;
    NSArray *transfers;
    Transfer *selectedTransfer;
    //要显示的月份详细信息的索引值
    int showMonthIndex;
    //进度条最大值
    double progressMaxValue;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao = [[DaoManager alloc] init];
    loginedUser = [dao.userDao getLoginedUser];
    //默认显示今年的数据
    yearDate = [NSDate date];
    //默认显示第一个月的详细视图
    showMonthIndex = 0;
    //进度条最大值默认值为0
    progressMaxValue = 0;
    //去掉表格分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置下拉加载上一年的数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        yearDate = [DateTool getADayOfLastYear:yearDate];
        [self setDataByYear];
        [self.tableView.mj_header endRefreshing];
    }];
    
    //设置上拉加载下一年的数据
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        yearDate = [DateTool getADayOfNextYear:yearDate];
        [self setDataByYear];
        [self.tableView.mj_footer endRefreshing];
    }];

    //根据当前默认年份设置要显示的数据
    [self setDataByYear];
}

-(void)viewDidAppear:(BOOL)animated {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    

}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if([segue.identifier isEqualToString:@"transferSegue"]) {
        TransferViewController *controller=(TransferViewController *)[segue destinationViewController];
        controller.transfer=selectedTransfer;
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return monthlyStatisticalDatas.count+transfers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UITableViewCell *cell=nil;
    //显示详细信息单元格
    if(showMonthIndex<indexPath.row&&indexPath.row<=showMonthIndex+transfers.count) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"transferCell"
                                             forIndexPath:indexPath];
        Transfer *transfer=[transfers objectAtIndex:indexPath.row-showMonthIndex-1];
        UILabel *dayLabel=(UILabel *)[cell viewWithTag:1];
        UIImageView *outAccountIconImageView=(UIImageView *)[cell viewWithTag:2];
        UILabel *accountsLaebl=(UILabel *)[cell viewWithTag:9];
        UILabel *moneyLabel=(UILabel *)[cell viewWithTag:4];
        dayLabel.text=[DateTool formateDate:transfer.time withFormat:DateFormatDay];
        outAccountIconImageView.image=[UIImage imageWithData:transfer.tfout.aicon.idata];
        accountsLaebl.text=[NSString stringWithFormat:@"%@ -> %@",transfer.tfout.aname,transfer.tfin.aname];
        moneyLabel.text=[NSString stringWithFormat:@"%@",transfer.money];
    }else{  //显示月份统计单元格
        cell=[tableView dequeueReusableCellWithIdentifier:@"monthCell"
                                             forIndexPath:indexPath];
        NSUInteger dataIndex=indexPath.row;
        if(indexPath.row>showMonthIndex+transfers.count)
            dataIndex-=transfers.count;
        TransferMonthlyStatisticalData *data=[monthlyStatisticalDatas objectAtIndex:dataIndex];
        UILabel *monthLabel=(UILabel *)[cell viewWithTag:1];
        UILabel *monthDurationLabel=(UILabel *)[cell viewWithTag:2];
        UILabel *transferAmountLabel=(UILabel *)[cell viewWithTag:3];
        UIProgressView *transferAmountProgressView=(UIProgressView *)[cell viewWithTag:4];
        monthLabel.text=[DateTool formateDate:data.date withFormat:DateFormatLocalMonth];
        NSDateComponents *components=[DateTool getDateComponents:[DateTool getThisMonthEnd:data.date]];
        int days=(int)components.day;
        int month=(int)components.month;
        monthDurationLabel.text=[NSString stringWithFormat:@"%d.01~%d.%d",month,month,days];
        transferAmountLabel.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:data.amount]];
        transferAmountProgressView.progress=1-data.amount/progressMaxValue;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //处理详细信息单元格点击事件
    if(showMonthIndex<indexPath.row&&indexPath.row<=showMonthIndex+transfers.count) {
        selectedTransfer=[transfers objectAtIndex:indexPath.row-showMonthIndex-1];
        [self performSegueWithIdentifier:@"transferSegue" sender:self];
    }else{  //处理月份统计单元格点击事件
        NSUInteger dataIndex=indexPath.row;
        if(indexPath.row>showMonthIndex+transfers.count)
            dataIndex-=transfers.count;
        //当当前月份的详细信息被展开时，就关闭
        if(dataIndex==showMonthIndex&&transfers!=nil)
            transfers=nil;
        else {
            //设置当前要显示的详细信息的单元格为点击的月份统计单元格对应月份的转账记录
            showMonthIndex=(int)dataIndex;
            TransferMonthlyStatisticalData *data =[monthlyStatisticalDatas objectAtIndex:dataIndex];
            transfers=[dao.transferDao findByAccountBook:loginedUser.usingAccountBook
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
    self.navigationItem.title=[NSString stringWithFormat:@"%@ in %@",TransferListNavigationTitle,
                               [DateTool formateDate:yearDate withFormat:DateFormatYear]];
    monthlyStatisticalDatas=[dao.transferDao getMonthlyStatisticalDataFrom:[DateTool getThisYearStart:yearDate]
                                                                        to:[DateTool getThisYearEnd:yearDate]
                                                             inAccountBook:loginedUser.usingAccountBook];
    if(monthlyStatisticalDatas.count>0) {
        progressMaxValue=0;
        for(TransferMonthlyStatisticalData *data in monthlyStatisticalDatas) {
            NSLog(@"%@ %f",[DateTool formateDate:data.date withFormat:DateFormatLocalMonth],data.amount);
            if(data.amount>progressMaxValue)
                progressMaxValue=data.amount;
        }
        TransferMonthlyStatisticalData *data=[monthlyStatisticalDatas objectAtIndex:0];
        transfers=[dao.transferDao findByAccountBook:loginedUser.usingAccountBook
                                                from:[DateTool getThisMonthStart:data.date]
                                                  to:[DateTool getThisMonthEnd:data.date]];
    }else{
        transfers=nil;
    }
    [self.tableView reloadData];
}

@end
