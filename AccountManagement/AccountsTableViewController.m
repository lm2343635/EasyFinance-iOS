//
//  AccountsTableViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/7.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AccountsTableViewController.h"
#import "DaoManager.h"

@interface AccountsTableViewController ()

@end

@implementation AccountsTableViewController {
    DaoManager *dao;
    User *loginedUser;
    NSArray *accounts;
    Account *selectedAccount;
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
    accounts=[loginedUser.usingAccountBook.accounts allObjects];
    [self.tableView reloadData];
}

#pragma mark - View
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return accounts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"accountCell"
                                                          forIndexPath:indexPath];
    UIImageView *accountIconImageView=(UIImageView *)[cell viewWithTag:1];
    UILabel *accountNameLabel=(UILabel *)[cell viewWithTag:2];
    Account *account=[accounts objectAtIndex:indexPath.row];
    accountIconImageView.image=[UIImage imageWithData:account.aicon.idata];
    accountNameLabel.text=account.aname;
    return cell;
}

@end
