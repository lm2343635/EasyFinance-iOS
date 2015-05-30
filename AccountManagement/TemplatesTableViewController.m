//
//  TemplatesTableViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/8.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "TemplatesTableViewController.h"
#import "DaoManager.h"

@interface TemplatesTableViewController ()

@end

@implementation TemplatesTableViewController {
    DaoManager *dao;
    User *loginedUser;
    NSArray *templates;
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
    templates=[dao.templateDao findByAccountBook:loginedUser.usingAccountBook];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return templates.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"templateCell"
                                                          forIndexPath:indexPath];
    cell.textLabel.text=[[templates objectAtIndex:indexPath.row] tpname];
    return cell;
}

@end
