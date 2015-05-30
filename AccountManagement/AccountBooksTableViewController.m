//
//  AccountBooksTableViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/4/25.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AccountBooksTableViewController.h"
#import "AccountBookViewController.h"
#import "DaoManager.h"

@interface AccountBooksTableViewController ()

@end

@implementation AccountBooksTableViewController{
    DaoManager *dao;
    User *loginedUser;
    NSArray *accountBooks;
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
    accountBooks=[dao.accountBookDao findByUser:loginedUser];
    [self.tableView reloadData];
}

#pragma mark - View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return accountBooks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountBookCell"
                                                            forIndexPath:indexPath];
    
    UIImageView *accountBookIconImageView=(UIImageView *)[cell viewWithTag:1];
    UILabel *accountBookNameLabel=(UILabel *)[cell viewWithTag:2];
    AccountBook *accountBook=[accountBooks objectAtIndex:indexPath.row];
    accountBookIconImageView.image=[UIImage imageWithData:accountBook.abicon.idata];
    accountBookNameLabel.text=accountBook.abname;
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue destinationViewController] isMemberOfClass:[AccountBookViewController class]]){
        UITableViewCell *clickedCell=(UITableViewCell *)sender;
        NSUInteger row=[[self.accountBooksTableView indexPathForCell:clickedCell] row];
        AccountBookViewController *destinationViewController=(AccountBookViewController *)[segue destinationViewController];
        destinationViewController.accountBook=[accountBooks objectAtIndex:row];
    }
}


@end
