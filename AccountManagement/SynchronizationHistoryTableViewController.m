//
//  SynchronizationHistoryTableViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/6/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "SynchronizationHistoryTableViewController.h"
#import "DaoManager.h"
#import "DateTool.h"

@interface SynchronizationHistoryTableViewController ()

@end

@implementation SynchronizationHistoryTableViewController {
    DaoManager *dao;
    User *loginedUser;
    NSArray *histories;
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
    [super viewWillAppear:animated];
    histories=[dao.synchronizationHistoryDao findByUser:loginedUser];
    [self.tableView reloadData];
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
    SynchronizationHistory *history=[histories objectAtIndex:indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"syncHistoryCell"
                                                          forIndexPath:indexPath];
    UILabel *timeLabel=(UILabel *)[cell viewWithTag:2];
    UILabel *deviceInfoLabel=(UILabel *)[cell viewWithTag:1];
    UILabel *ipLabel=(UILabel *)[cell viewWithTag:3];
    timeLabel.text=[DateTool formateDate:history.time withFormat:DateFormatYearMonthDayHourMinutesSecond];
    deviceInfoLabel.text=history.device;
    ipLabel.text=history.ip;
    return cell;
}

@end
