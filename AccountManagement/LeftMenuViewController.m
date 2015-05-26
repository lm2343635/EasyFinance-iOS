//
//  LeftMenuViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/25.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "DaoManager.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController {
    DaoManager *dao;
    User *user;
    NSArray *accountBooks;
    NSIndexPath *usingAccountBookIndexPath;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    user=[dao.userDao getLoginedUser];
    //读取账本信息
    accountBooks=[user.accountBooks allObjects];
    //设置默认账本
    [self setUsingAccountBook];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    AccountBook *accountBook=[accountBooks objectAtIndex:indexPath.row];
    accountBookIconImageView.image=[UIImage imageWithData:accountBook.abicon.idata];
    accountBookNameLabel.text=accountBook.abname;
    //设置默认账本的选中图标
    if(user.usingAccountBook==accountBook) {
        usingAccountBookIndexPath=indexPath;
        selectedAccountBookIconImageView.hidden=false;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //选择默认账本，加载视图
    UICollectionViewCell *usingAccountBookCell=[collectionView cellForItemAtIndexPath:usingAccountBookIndexPath];
    ((UIImageView *)[usingAccountBookCell viewWithTag:3]).hidden=true;
    UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    ((UIImageView *)[cell viewWithTag:3]).hidden=false;
    //选择默认账本，存储数据
    user.usingAccountBook=[accountBooks objectAtIndex:indexPath.row];
    [dao.cdh saveContext];
    //设置默认账本的
    [self setUsingAccountBook];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    ((UIImageView *)[cell viewWithTag:3]).hidden=true;
}

#pragma mark - Service
//设置默认账本
-(void)setUsingAccountBook {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //设置默认账本的label和imageView
    self.usingAccountBookLabel.text=user.usingAccountBook.abname;
    self.usingAccountBookImageView.image=[UIImage imageWithData:user.usingAccountBook.abicon.idata];
    //加载该账本的其他数据到MainViewController中
    //....
}
@end
