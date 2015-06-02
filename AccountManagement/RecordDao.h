//
//  RecordDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/4.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "Record.h"
#import "Classification.h"
#import "Account.h"
#import "Shop.h"
#import "User.h"

#define RecordEntityName @"Record"

@interface RecordDao : DaoTemplate
//从服务器导入默认数据使用，不需要更新账户、分类和商家的资金流入流出流出，以及对账历史记录
-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                         andMoney:(NSNumber *)money
                        andRemark:(NSString *)remark
                          andTime:(NSDate *)time
                andClassification:(Classification *)classsification
                       andAccount:(Account *)account
                          andShop:(Shop *)shop
                         andPhoto:(Photo *)photo
                    inAccountBook:(AccountBook *)accountBook;

//从服务器同步数据使用，要更新账户、分类和商家的资金流入流出流出，以及对账历史记录
-(NSManagedObjectID *)synchronizeWithSid:(NSNumber *)sid
                                andMoney:(NSNumber *)money
                               andRemark:(NSString *)remark
                                 andTime:(NSDate *)time
                       andClassification:(Classification *)classsification
                              andAccount:(Account *)account
                                 andShop:(Shop *)shop
                                andPhoto:(Photo *)photo
                           inAccountBook:(AccountBook *)accountBook;

//iOS客户端新建收支记录使用，必须更新账户、分类和商家的资金流入流出，以及对账历史记录
-(NSManagedObjectID *)saveWithMoney:(NSNumber *)money
                          andRemark:(NSString *)remark
                            andTime:(NSDate *)time
                  andClassification:(Classification *)classsification
                         andAccount:(Account *)account
                            andShop:(Shop *)shop
                           andPhoto:(Photo *)photo
                      inAccountBook:(AccountBook *)accountBook;

//得到某个账本的所有收支记录
-(NSArray *)findByAccountBook:(AccountBook *)accountBook;

//得到指定用户的所有未同步收支记录
-(NSArray *)findNotSyncByUser:(User *)user;

//得到某个账本在某个时间段的收支记录
-(NSArray *)findByAccountBook:(AccountBook *)accountBook
                         from:(NSDate *)start
                           to:(NSDate *)end;

//得到某日的指定账户的收支记录
-(NSArray *)findByAccount:(Account *)account
                   onDate:(NSDate *)date;



//按月份得到收支记录的统计信息
-(NSArray *)getMonthlyStatisticalDataFrom:(NSDate *)start
                                       to:(NSDate *)end
                            inAccountBook:(AccountBook *)accountBook;

//得到最新收支记录
-(Record *)getLatestRecordInAccountBook:(AccountBook *)accountBook;

//得到某个时间段的总支出
-(double)getTotalSpendFrom:(NSDate *)start
                        to:(NSDate *)end
             inAccountBook:(AccountBook *)accountBook;

//得到某个时间段的总收入
-(double)getTotalEarnFrom:(NSDate *)start
                       to:(NSDate *)end
            inAccountBook:(AccountBook *)accountBook;

@end
