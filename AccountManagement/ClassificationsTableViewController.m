//
//  ClassificationTableViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/7.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "ClassificationsTableViewController.h"
#import "DaoManager.h"

@interface ClassificationsTableViewController ()

@end

@implementation ClassificationsTableViewController {
    DaoManager *dao;
    NSArray *classifications;
    User *loginedUser;
    Classification *selectedClassification;
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
    classifications=[loginedUser.usingAccountBook.classifications allObjects];
    [self.tableView reloadData];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return classifications.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"classificationCell"
                                                          forIndexPath:indexPath];
    //分类图标
    UIImageView *classificationIconImageView=(UIImageView *)[cell viewWithTag:1];
    //分类名称
    UILabel *classificationNameLabel=(UILabel *)[cell viewWithTag:2];
    Classification *classification=[classifications objectAtIndex:indexPath.row];
    classificationIconImageView.image=[UIImage imageWithData:classification.cicon.idata];
    classificationNameLabel.text=classification.cname;
    return cell;
}

@end
