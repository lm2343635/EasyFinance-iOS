//
//  MainTableViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/25.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *usingAccountBookNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *usingAccountBookImageView;
@property (strong, nonatomic) IBOutlet UILabel *thisMonthTotalSpendLabel;
@property (strong, nonatomic) IBOutlet UILabel *thisMoneyTotalEarnLabel;

//账户信息
@property (strong, nonatomic) IBOutlet UILabel *totalAssetsMoneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLibilitiesMoneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *netAssetsMoneyLabel;


//最近一条收支记录
@property (strong, nonatomic) IBOutlet UIImageView *latestRecordClassificationIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *latestRecordClassificationLabel;
@property (strong, nonatomic) IBOutlet UILabel *latestRecordTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *latestRecordMoneyLabel;

//今天的收支记录
@property (strong, nonatomic) IBOutlet UILabel *todayDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *todayTimeInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *todaySpendLabel;
@property (strong, nonatomic) IBOutlet UILabel *todayEarnLabel;

//本周收支记录
@property (strong, nonatomic) IBOutlet UILabel *thisWeekTimeInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *thisWeekSpendLabel;
@property (strong, nonatomic) IBOutlet UILabel *thisWeekEarnLabel;

//本月收支记录
@property (strong, nonatomic) IBOutlet UILabel *thisMonthLocalNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *thisMonthTimeInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *thisMonthEarnLabel;
@property (strong, nonatomic) IBOutlet UILabel *thisMonthSpendLabel;

-(void)reloadData;
@end
