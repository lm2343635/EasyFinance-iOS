//
//  AccountBookDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/4/26.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "AccountBook.h"
#import "Icon.h"
#import "User.h"

#define AccountBookEntityName @"AccountBook"

@interface AccountBookDao : DaoTemplate

-(NSManagedObjectID *)saveWithName:(NSString *)abname
                           andIcon:(Icon *)abicon;

-(NSManagedObjectID *)saveWithName:(NSString *)abname
                           andIcon:(Icon *)abicon
                           andUser:(User *)user;

//导入服务器数据
-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                          andName:(NSString *)abname
                          andIcon:(Icon *)abicon
                          andUser:(User *)user;

//通过服务器id得到账本
-(AccountBook *)getBySid:(NSNumber *)sid;

//得到指定用户的所有账本，并按账本名称排序
-(NSArray *)findByUser:(User *)user;

//查找指定用户未同步的账本
-(NSArray *)findNotSyncByUser:(User *)user;

@end
