//
//  TransferDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/4.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "Transfer.h"
#import "Account.h"
#import "User.h"

@interface TransferDao : DaoTemplate
//从服务器导入转账记录使用，不需要更新账户的资金流入流出，以及对账历史记录
-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                         andMoney:(NSNumber *)money
                        andRemark:(NSString *)remark
                          andTime:(NSDate *)time
                    andOutAccount:(Account *)tfout
                     andInAccount:(Account *)tfin
                    inAccountBook:(AccountBook *)accountBook;

//从服务器同步转账记录使用，必须更新账户的资金流入流出，以及对账历史记录
-(NSManagedObjectID *)synchronizeWithSid:(NSNumber *)sid
                                andMoney:(NSNumber *)money
                               andRemark:(NSString *)remark
                                 andTime:(NSDate *)time
                           andOutAccount:(Account *)tfout
                            andInAccount:(Account *)tfin
                           inAccountBook:(AccountBook *)accountBook;

//iOS客户端新建转账记录使用，必须更新账户的资金流入流出，以及对账历史记录
-(NSManagedObjectID *)saveWithMoney:(NSNumber *)money
                          andRemark:(NSString *)remark
                            andTime:(NSDate *)time
                      andOutAccount:(Account *)tfout
                       andInAccount:(Account *)tfin
                      inAccountBook:(AccountBook *)accountBook;

//得到指定用户所有未同步的转账记录
-(NSArray *)findNotSyncByUser:(User *)user;

//得到指定账本中指定时间段的转账记录
-(NSArray *)findByAccountBook:(AccountBook *)accountBook
                         from:(NSDate *)start
                           to:(NSDate *)end;

//得到指定账户在指定时间段的月份统计数据
-(NSArray *)getMonthlyStatisticalDataFrom:(NSDate *)start
                                       to:(NSDate *)end
                            inAccountBook:(AccountBook *)accountBook;

//查询指定日期中指定转入账户的转账记录
-(NSArray *)findByTfin:(Account *)tfin
                onDate:(NSDate *)date;

//查询指定日期中指定转出账户的转账记录
-(NSArray *)findByTfout:(Account *)tfout
                 onDate:(NSDate *)date;

@end
