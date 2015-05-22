//
//  MainController.m
//  AccountManagement
//
//  Created by 李大爷 on 14/12/17.
//  Copyright (c) 2014年 李大爷. All rights reserved.
//

#import "MainViewController.h"
#import "DaoManager.h"

#define debug 1

@interface MainViewController ()

@end

@implementation MainViewController{
    DaoManager *dao;
    User *user;
    NSArray *accountBooks;
    NSIndexPath *usingAccountBookIndexPath;
    CGFloat centerX;
    CGFloat centerY;
    CGPoint translation;
    CGPoint menuTranslation;
}

CGFloat menuWidth=250;

- (void)viewDidLoad {
    if(debug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    user=[dao.userDao getLoginedUser];
    //读取账本信息
    accountBooks=[user.accountBooks allObjects];
    //设置菜单滑动手势
    [self setMenuGesture];
    //设置默认账本
    [self setUsingAccountBook];
}

//设置菜单滑动手势
-(void)setMenuGesture {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    // 存储坐标
    centerX = self.view.bounds.size.width/2;
    centerY = self.view.bounds.size.height/2-24;//减去24px的水平校验差
    // 屏幕边缘pan手势(优先级高于其他手势)
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture=[[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    leftEdgeGesture.edges=UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
    self.menuView.center=CGPointMake(-menuWidth/2, centerY);
}

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

#pragma mark - VIEW
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNo=indexPath.row;
    UITableViewCell *cell;
    if(rowNo==0)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"lastRecord" forIndexPath:indexPath];
        UIImageView *lastRecordIcon=(UIImageView *)[cell viewWithTag:1];
        UILabel *lastRecordName=(UILabel *)[cell viewWithTag:2];
        UILabel *lastRecordTime=(UILabel *)[cell viewWithTag:3];
        UILabel *lastRecordMoney=(UILabel *)[cell viewWithTag:4];
        lastRecordIcon.image=[UIImage imageNamed:@"d_nf"];
        lastRecordName.text=@"Milk";
        lastRecordTime.text=@"2014-12-15 16:22";
        lastRecordMoney.text=@"173.00";
    }
    else
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"timeInfo" forIndexPath:indexPath];
        UIImageView *timeInfoIcon=(UIImageView *)[cell viewWithTag:5];
        UILabel *timeInfoName=(UILabel *)[cell viewWithTag:6];
        UILabel *timeInfoTime=(UILabel *)[cell viewWithTag:7];
        UILabel *timeInfoSpend=(UILabel *)[cell viewWithTag:8];
        UILabel *timeInfoEarn=(UILabel *)[cell viewWithTag:9];
        switch (rowNo)
        {
            case 1:
                timeInfoIcon.image=[UIImage imageNamed:@"date_today"];
                timeInfoName.text=@"Today";
                timeInfoTime.text=@"December 17,2014";
                timeInfoSpend.text=@"246.00";
                timeInfoEarn.text=@"0.00";
                break;
            case 2:
                timeInfoIcon.image=[UIImage imageNamed:@"date_week"];
                timeInfoName.text=@"This Week";
                timeInfoTime.text=@"15,Dec~21,Dec";
                timeInfoSpend.text=@"2346.00";
                timeInfoEarn.text=@"4364.00";
                break;
            case 3:
                timeInfoIcon.image=[UIImage imageNamed:@"date_month"];
                timeInfoName.text=@"This Month";
                timeInfoTime.text=@"01,Dec~31,Dec";
                timeInfoSpend.text=@"27736.00";
                timeInfoEarn.text=@"9370.00";
                break;
        }
    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(debug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return [accountBooks count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(debug==1)
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

#pragma mark - Action
#define GESTURE_DEBUG 0
- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    if(DEBUG==1&&GESTURE_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if(gesture.state==UIGestureRecognizerStateBegan||gesture.state==UIGestureRecognizerStateChanged){
        // 根据被触摸手势的view计算得出坐标值
        translation=[gesture translationInView:gesture.view];
        if(DEBUG==1&&GESTURE_DEBUG==1)
            NSLog(@"translation.x=%f",translation.x);
        self.menuView.center = CGPointMake(-centerX+translation.x,centerY);
    }else{
        if(DEBUG==1&&GESTURE_DEBUG==1)
            NSLog(@"The last location is: %@", NSStringFromCGPoint(translation));
        //如果移动距离不足125px返回原点，否则补足至宽度250px
        if(translation.x<menuWidth/2){
            [UIView animateWithDuration:.3 animations:^{
                self.menuView.center = CGPointMake(-menuWidth/2,centerY);
            }];
        }else{
            [UIView animateWithDuration:.3 animations:^{
                self.menuView.center = CGPointMake(menuWidth/2,centerY);
            }];
        }
    }
}

- (IBAction)closeMemu:(UIPanGestureRecognizer *)gesture {
    if(DEBUG==1&&GESTURE_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if(gesture.state==UIGestureRecognizerStateBegan||gesture.state==UIGestureRecognizerStateChanged){
        menuTranslation=[gesture translationInView:self.menuView];
        if(menuTranslation.x<0)
            self.menuView.center=CGPointMake(menuWidth/2+menuTranslation.x, centerY);
    }else{
        if(menuTranslation.x>-100){
            [UIView animateWithDuration:.3 animations:^{
                self.menuView.center=CGPointMake(menuWidth/2, centerY);
            }];
        }else{
            [UIView animateWithDuration:.3 animations:^{
                self.menuView.center=CGPointMake(-menuWidth/2, centerY);
            }];
        }
    }
    
}
@end
