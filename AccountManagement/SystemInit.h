//
//  SystemInit.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InternetHelper.h"
#import "DaoManager.h"

#define ShowServerMessage 0

#define SYS_NULL_ID 1
#define SYS_RECORD_PHOTO_NULL 2
#define SYS_NULL_USER @"SYS_NULL_USER"
#define SYS_NULL_EMAIL @"SYS_NULL_EMAIL"
#define SYS_NULL_PASSWORD @"SYS_NULL_PASSWORD"
#define SYS_NULL_ICON @"SYS_NULL_ICON"
#define SYS_NULL_ACCOUNTBOOK @"SYS_NULL_ACCOUNTBOOK"
#define SYS_NULL_USER_PHOTO @"SYS_NULL_USER_PHOTO.png"
#define SYS_NULL_ACCOUNT @"SYS_NULL_ACCOUNT"
#define SYS_NULL_CLASSIFICATION @"SYS_NULL_CLASSIFICATION"
#define SYS_NULL_SHOP @"SYS_NULL_SHOP"
#define SYS_NULL_RECORD_PHOTO @"SYS_NULL_RECORD_PHOTO.png"
#define SYS_NULL_ICON_PHOTO @"SYS_NULL_ICON_PHOTO.png"

@interface SystemInit : NSObject

//导入系统空字段
-(void)createSystemNullItems;

//从服务器导入默认数据
-(void)importDefaultDataFromServer;

@end
