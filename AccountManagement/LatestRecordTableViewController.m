//
//  LatestRecordTableViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/18.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "LatestRecordTableViewController.h"
#import "RecordViewController.h"
#import "DaoManager.h"

@interface LatestRecordTableViewController ()

@end

@implementation LatestRecordTableViewController {
    DaoManager *dao;
    User *loginedUser;
    NSArray *records;
    Record *selectedRecord;
    NSDateFormatter *formatter;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    loginedUser=[dao.userDao getLoginedUser];
    records=[dao.recordDao findByAccountBook:loginedUser.usingAccountBook];
    formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    self.usingAccountBookNameLabel.text=loginedUser.usingAccountBook.abname;
    self.userPhotoImageView.image=[UIImage imageWithData:loginedUser.usingAccountBook.abicon.idata];
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

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return records.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Record *record=[records objectAtIndex:indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"latestRecord"
                                                          forIndexPath:indexPath];
    UIImageView *classificationIconImageView=(UIImageView *)[cell viewWithTag:1];
    UILabel *classificationNameLabel=(UILabel *)[cell viewWithTag:2];
    UILabel *informationLabel=(UILabel *)[cell viewWithTag:3];
    UILabel *moneyLabel=(UILabel *)[cell viewWithTag:4];
    UILabel *timeLabel=(UILabel *)[cell viewWithTag:5];
    classificationIconImageView.image=[UIImage imageWithData:record.classification.cicon.idata];
    classificationNameLabel.text=record.classification.cname;
    informationLabel.text=[NSString stringWithFormat:@"%@",record.account.aname];
    moneyLabel.text=[record.money stringValue];
    timeLabel.text=[formatter stringFromDate:record.time];
    if([record.money doubleValue]<=0)
        moneyLabel.textColor=[UIColor redColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    selectedRecord=[records objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"recordSegue" sender:self];
}

#pragma mark - Navigation
- (IBAction)back:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
