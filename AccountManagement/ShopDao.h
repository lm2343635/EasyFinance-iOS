//
//  ShopDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "Shop.h"
#import "User.h"

#define ShopEntityName @"Shop"

@interface ShopDao : DaoTemplate

//服务器导入账户使用
-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                         andSname:(NSString *)sname
                         andSicon:(Icon *)sicon
                           andSin:(NSNumber *)sin
                          andSout:(NSNumber *)sout
                    inAccountBook:(AccountBook *)accountBook;

//客户端新建账户使用
-(NSManagedObjectID *)saveWithAccountBook:(AccountBook *)accountBook
                                 andSname:(NSString *)sname
                                 andSicon:(Icon *)sicon;

-(Shop *)getBySid:(NSNumber *)sid;

//查询指定账本中的所有商家，并按商家名称排序
-(NSArray *)findByAccoutBook:(AccountBook *)accountBook;

//查询指定用户的所有未同步商家
-(NSArray *)findNotSyncByUser:(User *)user;

@end
