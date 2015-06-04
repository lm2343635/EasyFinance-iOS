//
//  InternetHelper.h
//  AccountManagement
//
//  Created by 李大爷 on 15/4/29.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Reachability.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

#define Domain @"easy.fczm.pw"
//#define Domain @"192.168.1.127:8080/EasyFinanceWeb"

#define InteretTestDomain @"easy.fczm.pw"

#define LOGIN_SUCCESS 0
#define LOGIN_PASSWORD_WRONG 1
#define LOGIN_NO_USING_ACCOUNT_BOOK 2

@interface InternetHelper : NSObject

//得到网络连接管理者
+(AFHTTPRequestOperationManager *)getRequestOperationManager;

//创建访问服务器的url
+(NSString *)createUrl:(NSString *)relativePosition;

+(NSInteger)testNetStatus;

+(NSString *)getDeviceInfo;

+ (void)getLANIPAddressWithCompletion:(void (^)(NSString *IPAddress))completion;

+ (void)getWANIPAddressWithCompletion:(void(^)(NSString *IPAddress))completion;

@end
