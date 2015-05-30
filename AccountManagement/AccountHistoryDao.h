//
//  AccountHistoryDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/27.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "AccountHistory.h"
#import "Account.h"
#import "User.h"

#define AccountHistoryEntityName @"AccountHistory"

@interface AccountHistoryDao : DaoTemplate

//导入服务器对账数据
-(NSManagedObjectID *)saveBySid:(NSNumber *)sid
                         andAin:(NSNumber *)ain
                        andAout:(NSNumber *)aout
                         onDate:(NSDate *)date
                      inAccount:(Account *)account;

//新建或更新对账历史记录
-(NSManagedObjectID *)updateWithMoney:(double)money
                               onDate:(NSDate *)date
                            inAccount:(Account *)account;

//得到指定时间段的对账单
-(NSArray *)findByAccount:(Account *)account
                     from:(NSDate *)start
                       to:(NSDate *)end;

//得到指定用户的所有未同步对账历史记录
-(NSArray *)findNotSyncByUser:(User *)user;

@end
