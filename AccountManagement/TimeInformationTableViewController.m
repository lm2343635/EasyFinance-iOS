//
//  TimeInformationTableViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/6/5.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "TimeInformationTableViewController.h"
#import "DaoManager.h"
#import "DateTool.h"
#import "RecordViewController.h"

@interface TimeInformationTableViewController ()

@end

@implementation TimeInformationTableViewController {
    DaoManager *dao;
    User *loginedUser;
    NSArray *records;
    Record *selectedRecord;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    loginedUser=[dao.userDao getLoginedUser];
    NSDate *start=(NSDate *)[self.navigationController valueForKey:@"start"];
    NSDate *end=(NSDate *)[self.navigationController valueForKey:@"end"];
    records=[dao.recordDao findByAccountBook:loginedUser.usingAccountBook
                                        from:start
                                          to:end];
    //设置TabBar选中文字的颜色
    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:TintColorRed
                                                                      green:TintColorGreen
                                                                       blue:TintColorBlue
                                                                      alpha:TintColorAlpha];
    //设置时间标题
    NSString *startStr=[DateTool formateDate:start withFormat:DateFormatYearMonthDay];
    NSString *endStr=[DateTool formateDate:end withFormat:DateFormatYearMonthDay];
    if([startStr isEqualToString:endStr])
        self.navigationItem.title=startStr;
    else
        self.navigationItem.title=[NSString stringWithFormat:@"%@ ~ %@",startStr,endStr];
    //设置收支信息
    double surplus,earn,spend,money;
    for(Record *record in records) {
        money=record.money.doubleValue;
        if(money>0)
            earn+=money;
        else
            spend-=money;
    }
    surplus=earn-spend;
    self.surplusLabel.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:surplus]];
    self.spendLabel.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:spend]];
    self.earnLabel.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:earn]];
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
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"recordCell"
                                                          forIndexPath:indexPath];
    Record *record=[records objectAtIndex:indexPath.row];
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
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    selectedRecord=[records objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"recordSegue" sender:self];
}

#pragma mark - Action
- (IBAction)back:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
