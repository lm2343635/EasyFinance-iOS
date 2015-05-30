//
//  ShopsTableViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/7.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "ShopsTableViewController.h"
#import "DaoManager.h"

@interface ShopsTableViewController ()

@end

@implementation ShopsTableViewController {
    DaoManager *dao;
    User *loginedUser;
    NSArray *shops;
    Shop *selectedShop;
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
    shops=[dao.shopDao findByAccoutBook:loginedUser.usingAccountBook];
    [self.tableView reloadData];
}

#pragma mark - View
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return shops.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"shopCell"
                                                          forIndexPath:indexPath];
    UIImageView *shopIconImageView=(UIImageView *)[cell viewWithTag:1];
    UILabel *shopNameLabel=(UILabel *)[cell viewWithTag:2];
    Shop *shop=[shops objectAtIndex:indexPath.row];
    shopIconImageView.image=[UIImage imageWithData:shop.sicon.idata];
    shopNameLabel.text=shop.sname;
    return cell;
}

@end
