//
//  SynchronizationHistoryDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/6/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "User.h"
#import "SynchronizationHistory.h"

#define SynchronizationHistoryEntityName @"SynchronizationHistory"

@interface SynchronizationHistoryDao : DaoTemplate

//导入服务器同步历史记录使用
-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                          andTime:(NSDate *)time
                            andIP:(NSString *)ip
                        andDevice:(NSString *)device
                           inUser:(User *)user;

//客户端新建同步历史记录使用
-(NSManagedObjectID *)saveWithTime:(NSDate *)time
                         andDevice:(NSString *)device
                            inUser:(User *)user;

//根据用户查找同步历史记录
-(NSArray *)findByUser:(User *)user;

@end
