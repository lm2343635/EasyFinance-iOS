//
//  RegisterViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/4/16.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailTextFeild;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextFeild;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextFeild;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *registActivityIndicatirView;
@property (strong, nonatomic) IBOutlet UIButton *registButton;

//注册提交
- (IBAction)regist:(id)sender;

//重置注册信息
- (IBAction)reset:(id)sender;

//返回登录界面
- (IBAction)signIn:(id)sender;

@end
