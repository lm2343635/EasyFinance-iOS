//
//  AccountDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "Account.h"
#import "AccountInformation.h"
#import "User.h"
#import "AccountBook.h"

#define AccountEntityName @"Account"

@interface AccountDao : DaoTemplate

//服务器导入账户使用
-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                         andAname:(NSString *)aname
                         andAicon:(Icon *)aicon
                           andAin:(NSNumber *)ain
                          andAout:(NSNumber *)aout
                    inAccountBook:(AccountBook *)accountBook;

//客户端新建账户使用
-(NSManagedObjectID *)saveWithAccountBook:(AccountBook *)accountBook
                                 andAname:(NSString *)aname
                                 andAicon:(Icon *)aicon
                                   andAin:(NSNumber *)ain;

-(Account *)getBySid:(NSNumber *)sid;

//获取账户中心信息
-(AccountInformation *)getAccountInformationInAccountBook:(AccountBook *)accountBook;

//得到指定账本的所有账户，并按账户名称排序
-(NSArray *)findByAccountBook:(AccountBook *)accountBook;

//得到指定用户的所有未同步账户
-(NSArray *)findNotSyncByUser:(User *)user;
@end
