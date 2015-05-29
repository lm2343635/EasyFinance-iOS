//
//  UserTableViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/6.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "UserTableViewController.h"
#import "DaoManager.h"

@interface UserTableViewController ()

@end

@implementation UserTableViewController {
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

#pragma mark - Action
- (IBAction)logout:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    loginedUser.login=[NSNumber numberWithBool:NO];
    [dao.cdh saveContext];
    [self performSegueWithIdentifier:@"logoutSegue" sender:self];
}
@end
