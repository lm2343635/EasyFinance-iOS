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

@interface TransferDao : DaoTemplate
//从服务器导入转账记录使用，不需要更新账户的资金流入流出
-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                         andMoney:(NSNumber *)money
                        andRemark:(NSString *)remark
                          andTime:(NSDate *)time
                    andOutAccount:(Account *)tfout
                     andInAccount:(Account *)tfin
                    inAccountBook:(AccountBook *)accountBook;

//iOS客户端新建转账记录使用，必须更新账户的资金流入流出
-(NSManagedObjectID *)saveWithMoney:(NSNumber *)money
                          andRemark:(NSString *)remark
                            andTime:(NSDate *)time
                      andOutAccount:(Account *)tfout
                       andInAccount:(Account *)tfin
                      inAccountBook:(AccountBook *)accountBook;

-(NSArray *)findByAccountBook:(AccountBook *)accountBook
                         from:(NSDate *)start
                           to:(NSDate *)end;

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
