//
//  RegisterViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/4/16.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "RegisterViewController.h"
#import "CreateAccountBookViewController.h"
#import "InternetHelper.h"
#import "DaoManager.h"
#import "User.h"
#import "Util.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController {
    DaoManager *dao;
    AFHTTPRequestOperationManager *manager;
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
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if([segue.identifier isEqualToString:@"registSuccessSegue"]) {
        CreateAccountBookViewController *createAccountBookViewController=(CreateAccountBookViewController *)[segue destinationViewController];
        createAccountBookViewController.email=self.emailTextFeild.text;
    }
}

#pragma mark - View

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

#pragma mark - Action
- (IBAction)regist:(id)sender
{
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSString *email=self.emailTextFeild.text;
    NSString *uname=self.usernameTextFeild.text;
    NSString *password=self.passwordTextFeild.text;
    if([email isEqualToString:@""]||[uname isEqualToString:@""]||[password isEqualToString:@""])
        [Util showAlert:@"Email, username or password is null, please submit again after checking your email address, username and password"];
    else {
        //验证邮箱是否存在
        [self.registActivityIndicatirView startAnimating];
        self.registButton.enabled=NO;
        [manager POST:[InternetHelper createUrl:@"iOSUserServlet?task=isEmailExsit"]
           parameters:@{@"email":email}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if(DEBUG==1)
                      NSLog(@"Get message from server: %@",operation.responseString);
                  if([operation.responseString boolValue]==YES)
                      [Util showAlert:@"The email address you input is already exsit."];
                  else {
                      NSMutableDictionary *parameter=[[NSMutableDictionary alloc] init];
                      [parameter setValue:email forKey:@"email"];
                      [parameter setValue:uname forKey:@"uname"];
                      [parameter setValue:password forKey:@"password"];
                      //在服务器中注册用户
                      [manager POST:[InternetHelper createUrl:@"iOSUserServlet?task=register"]
                         parameters:parameter
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                if(DEBUG==1)
                                    NSLog(@"Get message from server: %@",operation.responseString);
                                NSObject *object=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                 options:NSJSONReadingMutableContainers
                                                                                   error:nil];
                                //注册成功跳转到新建账本界面
                                if(object!=nil)
                                    [self performSegueWithIdentifier:@"registSuccessSegue" sender:self];
                            } 
                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                [self.registActivityIndicatirView stopAnimating];
                                self.registButton.enabled=YES;
                                NSLog(@"Server Error: %@",error);
                            }];
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [self.registActivityIndicatirView stopAnimating];
                  self.registButton.enabled=YES;
                  NSLog(@"Server Error: %@",error);
              }];
    }
}

- (IBAction)reset:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    self.emailTextFeild.text=@"";
    self.passwordTextFeild.text=@"";
    self.usernameTextFeild.text=@"";
}


- (IBAction)signIn:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
