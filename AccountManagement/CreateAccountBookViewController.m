//
//  CreateAccountBookViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/4/29.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "CreateAccountBookViewController.h"
#import "InternetHelper.h"
#import "Util.h"


@interface CreateAccountBookViewController ()

@end

@implementation CreateAccountBookViewController {
    AFHTTPRequestOperationManager *manager;
    DaoManager *dao;
    NSArray *icons;
    Icon *selectedIcon;
    NSManagedObjectID *uid;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    manager=[InternetHelper getRequestOperationManager];
    dao=[[DaoManager alloc] init];
    [self importOnlyUser];
    icons=[dao.iconDao findByType:IconTypeAccountBook];
    selectedIcon=nil;
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - View
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return icons.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"accountBookCell"
                                                                         forIndexPath:indexPath];
    UIImageView *accountBookIconImageView=(UIImageView *)[cell viewWithTag:AccountBookCellIcon];
    Icon *icon=[icons objectAtIndex:indexPath.row];
    accountBookIconImageView.image=[UIImage imageWithData:icon.idata];
    return cell;
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *selectedIconImageView=(UIImageView *)[cell viewWithTag:AccountBookCellSelectedIcon];
    selectedIconImageView.hidden=false;
    selectedIcon=[icons objectAtIndex:indexPath.row];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *selectedIconImageView=(UIImageView *)[cell viewWithTag:AccountBookCellSelectedIcon];
    selectedIconImageView.hidden=true;
}

#pragma mark - Action
- (IBAction)finishEdit:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [sender resignFirstResponder];
}

//保存账本
- (IBAction)saveAccountBook:(id)sender {
    if(DEBUG==1) {
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
        NSLog(@"Saving accountbook for user(uid=%@)",uid);
    }
    NSString *accountBookName=self.accountBookNameTextField.text;
    if([accountBookName isEqualToString:@""]||selectedIcon==nil)
        [Util showAlert:@"Please input account book and choose an icon for it."];
    else {
        User *user=(User *)[dao getObjectById:uid];
        //在服务器中创建账本，创建成功后返回账本信息
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];
        [parameters setValue:accountBookName forKey:@"abname"];
        [parameters setValue:user.sid forKey:@"uid"];
        [parameters setValue:selectedIcon.sid forKey:@"iid"];
        //按键不可用，活动监视器启动
        [self.saveAccountBookActivityIndicatorView startAnimating];
        self.saveAccountBookButton.enabled=NO;
        //在服务器中创建新账本
        [manager POST:[InternetHelper createUrl:@"iOSAccountBookServlet?task=add"]
           parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if(DEBUG==1)
                      NSLog(@"Get message from server: %@",operation.responseObject);
                  NSObject *object=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:nil];
                  int sabid=[[object valueForKey:@"abid"] intValue];
                  //服务器创建账本成功，则iOS本机也创建账本
                  if(sabid>0) {
                      NSManagedObjectID *abid=[dao.accountBookDao saveWithSid:[NSNumber numberWithInt:sabid]
                                                                      andName:accountBookName
                                                                      andIcon:selectedIcon
                                                                      andUser:user];
                      if(DEBUG==1)
                          NSLog(@"Create a new account book(abid=%@)",abid);
                      AccountBook *accountBook=(AccountBook *)[dao getObjectById:abid];
                      //把这个新账本添加到当前用户的账本列表里
                      [user addAccountBooksObject:accountBook];
                      //并且把这个新的账本设置为当前用户的默认账本
                      user.usingAccountBook=accountBook;
                      [dao.cdh saveContext];
                      //成功保存账本之后登陆系统，此时不需要加载服务器的所有数据，因为用户连账本都没有，不可能有其他的数据
                      //此时不需要访问服务器，直接将iOS本机数据库的user.login=YES，之后启动应用跳过登陆界面，直接登录系统即可
                      [dao.userDao setUserLogin:YES withUid:uid];
                  }
                  //服务器返回信息成功后按键回复可用，活动监视器暂停
                  [self.saveAccountBookActivityIndicatorView stopAnimating];
                  self.saveAccountBookButton.enabled=YES;
                  //跳转到Main之前设置用户已登录
                  [dao.userDao setUserLogin:YES withUid:uid];
                  //创建账本成功且登录成功跳转到MainTabBarController
                  [self performSegueWithIdentifier:@"setAccountBookSuccessSegue" sender:self];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  //服务器返回信息成功后按键回复可用，活动监视器暂停
                  [self.saveAccountBookActivityIndicatorView stopAnimating];
                  self.saveAccountBookButton.enabled=YES;
                  NSLog(@"Server Error: %@",error);
              }];
    }
}

#pragma mark - Data
-(void)importOnlyUser {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    User *user=[dao.userDao getByEmail:self.email];
    //当用户在iOS客户端数据库中已经存在，就不用再次从服务器导入了
    if(user!=nil) {
        uid=user.objectID;
        self.saveAccountBookButton.enabled=YES;
    }else{
        [manager POST:[InternetHelper createUrl:@"iOSUserServlet?task=getUser"]
           parameters:@{@"email":self.email}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if(DEBUG==1)
                      NSLog(@"Get message from server: %@",operation.responseString);
                  NSObject *object=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:nil];
                  //把服务器的用户导入iOS客户端数据库
                  uid=[dao.userDao saveWithEmail:[object valueForKey:@"email"]
                                        andUname:[object valueForKey:@"uname"]
                                     andPassword:[object valueForKey:@"password"]
                                          andSid:[NSNumber numberWithInt:[[object valueForKey:@"uid"] intValue]]];
                  if(DEBUG==1)
                      NSLog(@"Create user(uid=%@)",uid);
                  //只有导入用户完成后才能保存账本，此时将保存账本按钮设为可用
                  self.saveAccountBookButton.enabled=YES;
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Server Error: %@",error);
              }];
    }
}

@end
