//
//  AccountViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/27.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.selectedItem.selectedImage=[UIImage imageNamed:@"tab_account_selected"];
}

@end
