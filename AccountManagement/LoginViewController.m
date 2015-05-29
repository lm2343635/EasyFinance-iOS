//
//  LoginViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/4/16.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "LoginViewController.h"
#import "CreateAccountBookViewController.h"
#import "ImportUserViewController.h"
#import "InternetHelper.h"
#import "DaoManager.h"
#import "Util.h"
#import "SystemInit.h"
#import "Synchronization.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    AFHTTPRequestOperationManager *manager;
    DaoManager *dao;
}

-(void)viewDidAppear:(BOOL)animated {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidAppear:animated];
    //当已经存在登录用户,跳过登录界面，直接登录即可
    if([dao.userDao getLoginedUser]!=nil)
        [self performSegueWithIdentifier:@"loginSuccessSegue" sender:self];
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    manager=[InternetHelper getRequestOperationManager];
    dao=[[DaoManager alloc] init];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"noAccountBookSegue"]) {
        CreateAccountBookViewController *controller=(CreateAccountBookViewController *)[segue destinationViewController];
        controller.email=self.emailTextFeild.text;
    } else if ([segue.identifier isEqualToString:@"importUserInfoSegue"]) {
        ImportUserViewController *controller=(ImportUserViewController *)[segue destinationViewController];
        controller.email=self.emailTextFeild.text;
    }
}

#pragma mark - Action
- (IBAction)login:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSString *email=self.emailTextFeild.text;
    NSString *password=self.passwordTextField.text;
    if([email isEqualToString:@""]||[password isEqualToString:@""])
       [Util showAlert:@"Email or password is null."];
    else {
        [manager POST:[InternetHelper createUrl:@"iOSUserServlet?task=login"]
           parameters:@{@"email":email,@"password":password}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if(DEBUG==1)
                      NSLog(@"Get user login status from server: %@",operation.responseString);
                  int status=[operation.responseString intValue];
                  switch (status) {
                      case LOGIN_SUCCESS: {
                          User *user=[dao.userDao getByEmail:email];
                          NSLog(@"%@ %@",user,email);
                          if(user!=nil) {
                              //设置当前用户为已登录状态
                              [dao.userDao setUserLogin:YES withUid:user.objectID];
                              //注册同步密钥
                              Synchronization *sync=[[Synchronization alloc] init];
                              [sync registSyncKey];
                              //登录成功且用户在iOS中存在，直接跳转到主界面
                              [self performSegueWithIdentifier:@"loginSuccessSegue" sender:self];
                          }else{
                              //用户在iOS中不存在，跳转到导入页面
                              [self performSegueWithIdentifier:@"importUserInfoSegue" sender:self];
                          }
                          break;
                      }
                      case LOGIN_PASSWORD_WRONG:
                          [Util showAlert:@"Email or password is wrong, please sign in again after checking your email address and password"];
                          break;
                      case LOGIN_NO_USING_ACCOUNT_BOOK:
                          [self performSegueWithIdentifier:@"noAccountBookSegue" sender:self];
                          break;
                      default:
                          break;
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Server Error: %@",error);
              }];
    }
}

#pragma mark - Delegate: UITextFeildDelegate
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    CGRect frame = textField.frame;
    int offset=frame.origin.y+textField.frame.size.height-(self.view.frame.size.height-KeyboardHeight);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame=CGRectMake(0.0f,-offset,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

@end
