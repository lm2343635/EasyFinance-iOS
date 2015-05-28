//
//  AccountStatementsTableViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/27.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AccountStatementsTableViewController.h"
#import "DetailStatementTableViewController.h"
#import "DaoManager.h"

@interface AccountStatementsTableViewController ()

@end

@implementation AccountStatementsTableViewController {
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
    [super viewWillAppear:animated];
    accounts=[loginedUser.usingAccountBook.accounts allObjects];
    AccountInformation *information=[dao.accountDao getAccountInformationInAccountBook:loginedUser.usingAccountBook];
    self.netAssetsLabel.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:information.netAssets]];
    self.totalAssetsLabel.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:information.totalAssets]];
    self.totalLibilities.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:information.totaLibilities]];
    [self.tableView reloadData];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if([segue.identifier isEqualToString:@"detailStatementSegue"]) {
        DetailStatementTableViewController *controller=(DetailStatementTableViewController *)[segue destinationViewController];
        controller.account=selectedAccount;
    }
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return accounts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"accountCell"
                                                          forIndexPath:indexPath];
    Account *account=[accounts objectAtIndex:indexPath.row];
    UIImageView *accountIconImageView=(UIImageView *)[cell viewWithTag:1];
    UILabel *accountNameLabel=(UILabel *)[cell viewWithTag:2];
    UILabel *informationLabel=(UILabel *)[cell viewWithTag:3];
    UILabel *surplusLabel=(UILabel *)[cell viewWithTag:5];
    accountIconImageView.image=[UIImage imageWithData:account.aicon.idata];
    accountNameLabel.text=account.aname;
    informationLabel.text=[NSString stringWithFormat:@"inflows: %@, outflows: %@",account.ain,account.aout];
    surplusLabel.text=[NSString stringWithFormat:@"%@",
                       [NSNumber numberWithDouble:account.ain.doubleValue-account.aout.doubleValue]];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    selectedAccount=[accounts objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"detailStatementSegue" sender:self];
}
@end
