//
//  RecordDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/4.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "Record.h"

#define RecordEntityName @"Record"

@interface RecordDao : DaoTemplate

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                         andMoney:(NSNumber *)money
                        andRemark:(NSString *)remark
                          andTime:(NSDate *)time
                andClassification:(Classification *)classsification
                       andAccount:(Account *)account
                          andShop:(Shop *)shop
                         andPhoto:(Photo *)photo
                    inAccountBook:(AccountBook *)accountBook;

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

//得到某个账本在某个时间段的收支记录
-(NSArray *)findByAccountBook:(AccountBook *)accountBook
                         from:(NSDate *)start
                           to:(NSDate *)end;


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
