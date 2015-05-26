//
//  MainTableViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/25.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "MainTableViewController.h"
#import "DaoManager.h"
#import "DateTool.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController {
    DaoManager *dao;
    User *loginedUser;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    loginedUser=[dao.userDao getLoginedUser];
   }

-(void)viewWillAppear:(BOOL)animated {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSDate *nowDate=[NSDate date];
    AccountBook *usingAccountBook=loginedUser.usingAccountBook;
    //设置顶部本月收支信息和正在使用的账本信息
    self.timeLabel.text=[DateTool formateDate:[NSDate date] withFormat:DateFormatLocalMonthYear];
    self.usingAccountBookNameLabel.text=usingAccountBook.abname;
    self.usingAccountBookImageView.image=[UIImage imageWithData:usingAccountBook.abicon.idata];
    //设置最近一条收支记录的信息
    Record *latestRecord=[dao.recordDao getLatestRecordInAccountBook:usingAccountBook];
    self.latestRecordClassificationIconImageView.image=[UIImage imageWithData:latestRecord.classification.cicon.idata];
    self.latestRecordClassificationLabel.text=latestRecord.classification.cname;
    self.latestRecordTimeLabel.text=[DateTool formateDate:latestRecord.time withFormat:DateFormatYearMonthDayHourMinutes];
    self.latestRecordMoneyLabel.text=[NSString stringWithFormat:@"%@",latestRecord.money];
    if([latestRecord.money doubleValue]<=0)
        self.latestRecordMoneyLabel.textColor=[UIColor redColor];
    //设置本日收支记录信息
    NSDate *todayStart=[DateTool getThisDayStart:nowDate];
    NSDate *todayEnd=[DateTool getThisDayEnd:nowDate];
    double todaySpend=[dao.recordDao getTotalSpendFrom:todayStart
                                                    to:todayEnd
                                         inAccountBook:usingAccountBook];
    double todayEarn=[dao.recordDao getTotalEarnFrom:todayStart
                                                  to:todayEnd
                                       inAccountBook:usingAccountBook];
    self.todaySpendLabel.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:todaySpend]];
    self.todayEarnLabel.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:todayEarn]];
    self.todayDateLabel.text=[DateTool formateDate:nowDate withFormat:DateFormatDay];
    self.todayTimeInfoLabel.text=[DateTool formateDate:nowDate withFormat:DateFormatYearMonthDay];
    //设置本周收支记录信息
    NSDate *thisWeekStart=[DateTool getThisWeekStart:nowDate];
    NSDate *thisWeekEnd=[DateTool getThisWeekEnd:nowDate];
    double thisWeekSpend=[dao.recordDao getTotalSpendFrom:thisWeekStart
                                                       to:thisWeekEnd
                                            inAccountBook:usingAccountBook];
    double thisWeekEarn=[dao.recordDao getTotalEarnFrom:thisWeekStart
                                                     to:thisWeekEnd
                                          inAccountBook:usingAccountBook];
    self.thisWeekSpendLabel.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:thisWeekSpend]];
    self.thisWeekEarnLabel.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:thisWeekEarn]];
    self.thisWeekTimeInfoLabel.text=[NSString stringWithFormat:@"%@ ~ %@",
                                     [DateTool formateDate:thisWeekStart withFormat:DateFormatYearMonthDay],
                                     [DateTool formateDate:thisWeekEnd withFormat:DateFormatYearMonthDay]];
    //设置本月收支记录信息
    NSDate *thisMonthStart=[DateTool getThisMonthStart:nowDate];
    NSDate *thisMonthEnd=[DateTool getThisMonthEnd:nowDate];
    double thisMonthSpend=[dao.recordDao getTotalSpendFrom:thisMonthStart
                                                        to:thisMonthEnd
                                             inAccountBook:usingAccountBook];
    double thisMonthEarn=[dao.recordDao getTotalEarnFrom:thisMonthStart
                                                      to:thisMonthEnd
                                           inAccountBook:usingAccountBook];
    self.thisMonthSpendLabel.text=self.thisMonthTotalSpendLabel.text=
        [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:thisMonthSpend]];
    self.thisMonthEarnLabel.text=self.thisMoneyTotalEarnLabel.text=
        [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:thisMonthEarn]];
    self.thisMonthLocalNameLabel.text=[DateTool formateDate:nowDate withFormat:DateFormatLocalMonth];
    self.thisMonthTimeInfoLabel.text=[NSString stringWithFormat:@"%@ ~ %@",
                                      [DateTool formateDate:thisMonthStart withFormat:DateFormatYearMonthDay],
                                      [DateTool formateDate:thisMonthEnd withFormat:DateFormatYearMonthDay]];
}



@end
