//
//  UserDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "User.h"

#define UserEntityName @"User"

@interface UserDao : DaoTemplate

-(NSManagedObjectID *)saveWithEmail:(NSString *)email
                           andUname:(NSString *)uname
                        andPassword:(NSString *)password
                             andSid:(NSNumber *)sid;

//通过服务器用户id得到用户
-(User *)getBySid:(NSNumber *)sid;

//通过email得到用户
-(User *)getByEmail:(NSString *)email;

//得到当前登录的用户
-(User *)getLoginedUser;

//设置用户在iOS客户端的登录状态
-(void)setUserLogin:(BOOL)login withUid:(NSManagedObjectID *)uid;

@end
