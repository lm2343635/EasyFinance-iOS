//
//  RecordViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/18.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    [self.takePhotoButton setImage:[UIImage imageWithData:self.record.photo.pdata]
                          forState:UIControlStateNormal];
    self.moneyTextFeild.text=[self.record.money stringValue];
    [self.selectClassificationButton setTitle:self.record.classification.cname
                                     forState:UIControlStateNormal];
    self.selectClassificationIconImageView.image=[UIImage imageWithData:self.record.classification.cicon.idata];
    [self.selectAccountButton setTitle:self.record.account.aname
                              forState:UIControlStateNormal];
    self.selectAccountIconImageView.image=[UIImage imageWithData:self.record.account.aicon.idata];
    [self.selectShopButton setTitle:self.record.shop.sname
                           forState:UIControlStateNormal];
    self.selectShopIconImageView.image=[UIImage imageWithData:self.record.shop.sicon.idata];
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [self.selectTimeButton setTitle:[dateFormatter stringFromDate:self.record.time]
                           forState:UIControlStateNormal];
    self.remarkTextView.text=self.record.remark;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Action
- (IBAction)back:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
