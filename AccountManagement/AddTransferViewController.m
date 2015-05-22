//
//  AddTransferController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/1/14.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AddTransferViewController.h"
#import "DaoManager.h"

@interface AddTransferViewController ()

@end

@implementation AddTransferViewController {
    DaoManager *dao;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
}

#pragma mark - Action
- (IBAction)closeAddTransfer:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveTransfer:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    
}
@end
