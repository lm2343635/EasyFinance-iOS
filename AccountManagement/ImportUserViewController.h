//
//  ImportUserViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/7.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ImportUserInfoStatusStart 0
#define ImportUserInfoStatusAccountBooks 1
#define ImportUserInfoStatudUsingAccountBook 2
#define ImportUserInfoStatusClassification 3
#define ImportUserInfoStatusAccount 4
#define ImportUserInfoStatusShop 5
#define ImportUserInfoStatusTemplate 6
#define ImportUserInfoStatusPhoto 7
#define ImportUserInfoStatusIcon 8
#define ImportUserInfoStatusRecord 9
#define ImportUserInfoStatusTransfer 10

@interface ImportUserViewController : UIViewController

@property (nonatomic) NSInteger importUserInfoStatus;//导入用户数据监听状态位
@property (nonatomic) NSInteger importSupportClassIndex;//导入辅助类监Classificaiton,Account,Shop,Template听状态位

@property (strong, nonatomic) NSString *email;

@property (strong, nonatomic) IBOutlet UITextView *consoleTextView;

@end
