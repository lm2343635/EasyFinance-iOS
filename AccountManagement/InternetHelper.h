//
//  InternetHelper.h
//  AccountManagement
//
//  Created by 李大爷 on 15/4/29.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

#define Server @"120.25.237.244"
#define WebServiceName @"AccountManagement"

#define LOGIN_SUCCESS 0
#define LOGIN_PASSWORD_WRONG 1
#define LOGIN_NO_USING_ACCOUNT_BOOK 2

@interface InternetHelper : NSObject

//得到网络连接管理者
+(AFHTTPRequestOperationManager *)getRequestOperationManager;

//创建访问服务器的url
+(NSString *)createUrl:(NSString *)relativePosition;

@end
