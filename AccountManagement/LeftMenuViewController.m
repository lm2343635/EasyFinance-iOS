//
//  LeftMenuViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/25.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "DaoManager.h"
#import "Synchronization.h"
#import "SynchronizeViewController.h"
#import "Util.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController {
    DaoManager *dao;
    User *loginedUser;
    NSArray *accountBooks;
    NSIndexPath *usingAccountBookIndexPath;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewWillAppear:animated];
    loginedUser=[dao.userDao getLoginedUser];
    //读取账本信息
    accountBooks=[dao.accountBookDao findByUser:loginedUser];
    //设置默认账本
    [self setUsingAccountBook];
    [self.accountBooksCollectionView reloadData];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    SynchronizeViewController *controller=(SynchronizeViewController *)[segue destinationViewController];
    controller.modalPresentationStyle=UIModalPresentationOverCurrentContext;
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return [accountBooks count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"accountBookCell"
                                                                         forIndexPath:indexPath];
    UIImageView *accountBookIconImageView=(UIImageView *)[cell viewWithTag:1];
    UILabel *accountBookNameLabel=(UILabel *)[cell viewWithTag:2];
    UIImageView *selectedAccountBookIconImageView=(UIImageView *)[cell viewWithTag:3];
    selectedAccountBookIconImageView.hidden=YES;
    AccountBook *accountBook=[accountBooks objectAtIndex:indexPath.row];
    accountBookIconImageView.image=[UIImage imageWithData:accountBook.abicon.idata];
    accountBookNameLabel.text=accountBook.abname;
    //设置默认账本的选中图标
    if(loginedUser.usingAccountBook.objectID==accountBook.objectID) {
        usingAccountBookIndexPath=indexPath;
        selectedAccountBookIconImageView.hidden=NO;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //选择默认账本，加载视图
    UICollectionViewCell *usingAccountBookCell=[collectionView cellForItemAtIndexPath:usingAccountBookIndexPath];
    ((UIImageView *)[usingAccountBookCell viewWithTag:3]).hidden=true;
    UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    ((UIImageView *)[cell viewWithTag:3]).hidden=false;
    //选择默认账本，存储数据
    loginedUser.usingAccountBook=[accountBooks objectAtIndex:indexPath.row];
    [dao.cdh saveContext];
    //设置默认账本的
    [self setUsingAccountBook];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    ((UIImageView *)[cell viewWithTag:3]).hidden=YES;
}

#pragma mark - Action
- (IBAction)synchronize:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self.sideMenuViewController hideMenuViewController];
    if([InternetHelper testNetStatus]!=NotReachable)
        [self performSegueWithIdentifier:@"synchronizaSegue" sender:self];
    else
        [Util showAlert:@"Cannot connect to server, please check your Internet Connection!"];
    
}

#pragma mark - Service
//设置默认账本
-(void)setUsingAccountBook {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //设置默认账本的label和imageView
    self.usingAccountBookLabel.text=loginedUser.usingAccountBook.abname;
    self.usingAccountBookImageView.image=[UIImage imageWithData:loginedUser.usingAccountBook.abicon.idata];
    //加载该账本的其他数据到MainViewController中
    //....
}

@end
