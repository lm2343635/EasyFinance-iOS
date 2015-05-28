//
//  DetailStatementTableViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/27.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DetailStatementTableViewController.h"
#import "DateTool.h"

@interface DetailStatementTableViewController ()

@end

@implementation DetailStatementTableViewController {
    DaoManager *dao;
    NSArray *histories;
    AccountHistory *historyBeforeTheFirst;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    //设置标题名称为账本名称
    self.navigationItem.title=self.account.aname;
}

-(void)viewWillAppear:(BOOL)animated {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSDate *nowDate=[NSDate date];
    NSDate *start=[DateTool getThisMonthStart:nowDate];
    NSDate *end=[DateTool getThisDayEnd:nowDate];
    histories=[dao.accountHistoryDao findByAccount:self.account
                                              from:start
                                                to:end];
    //在histories之前的History用于计算第一个History的todayInflow和todayOutflow
    historyBeforeTheFirst=nil;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return histories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"detailStatementCell"
                                                          forIndexPath:indexPath];
    AccountHistory *history=[histories objectAtIndex:indexPath.row];
    //得到第一个history之前的history
    AccountHistory *lastHistory=historyBeforeTheFirst;
    if(indexPath.row>0)
        lastHistory=[histories objectAtIndex:indexPath.row-1];
    //计算今日自己流入流出
    double todayInflow=history.ain.doubleValue;
    double todayOutflow=history.aout.doubleValue;
    if(lastHistory!=nil) {
        todayInflow-=lastHistory.ain.doubleValue;
        todayOutflow-=lastHistory.aout.doubleValue;
    }
    UILabel *monthLabel=(UILabel *)[cell viewWithTag:1];
    UILabel *dayLabel=(UILabel *)[cell viewWithTag:2];
    UILabel *todayInflowLabel=(UILabel *)[cell viewWithTag:3];
    UILabel *todayOutflowLabel=(UILabel *)[cell viewWithTag:4];
    UILabel *totalInflowLabel=(UILabel *)[cell viewWithTag:5];
    UILabel *totalOutflowLabel=(UILabel *)[cell viewWithTag:6];
    UILabel *surplusLabel=(UILabel *)[cell viewWithTag:7];
    monthLabel.text=[DateTool formateDate:history.date withFormat:DateFormatMonth];
    dayLabel.text=[DateTool formateDate:history.date withFormat:DateFormatDay];
    todayInflowLabel.text=[NSString stringWithFormat:@"in: %@",[NSNumber numberWithDouble:todayInflow]];
    todayOutflowLabel.text=[NSString stringWithFormat:@"out: %@",[NSNumber numberWithDouble:todayOutflow]];
    totalInflowLabel.text=[NSString stringWithFormat:@"in: %@",history.ain];
    totalOutflowLabel.text=[NSString stringWithFormat:@"out: %@",history.aout];
    surplusLabel.text=[NSString stringWithFormat:@"%@",
                       [NSNumber numberWithDouble:history.ain.doubleValue-history.aout.doubleValue]];
    return cell;
}
@end
