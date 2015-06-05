//
//  SettingsTableViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/6/5.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AppDelegate.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置TabBar选中文字的颜色
    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:TintColorRed
                                                                      green:TintColorGreen
                                                                       blue:TintColorBlue
                                                                      alpha:TintColorAlpha];
}

@end
