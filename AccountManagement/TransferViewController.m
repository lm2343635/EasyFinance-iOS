//
//  TransferViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/24.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "TransferViewController.h"
#import "DateTool.h"

@interface TransferViewController ()

@end

@implementation TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.moneyTextField.text=[NSString stringWithFormat:@"%@",self.transfer.money];
    self.selectOutAccountImageView.image=[UIImage imageWithData:self.transfer.tfout.aicon.idata];
    [self.selectOutAccountButton setTitle:self.transfer.tfout.aname
                                 forState:UIControlStateNormal];
    self.selectInAccountImageView.image=[UIImage imageWithData:self.transfer.tfin.aicon.idata];
    [self.selectInAccountButton setTitle:self.transfer.tfin.aname
                                forState:UIControlStateNormal];
    [self.selectTimeButton setTitle:[DateTool formateDate:self.transfer.time
                                               withFormat:DateFormatYearMonthDayHourMinutes]
                           forState:UIControlStateNormal];
    self.remarkTextView.text=self.transfer.remark;
}


@end
