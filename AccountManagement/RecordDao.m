//
//  RecordDao.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/4.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "RecordDao.h"
#import "DateTool.h"
#import "RecordMonthlyStatisticalData.h"
#import "AccountHistoryDao.h"

@implementation RecordDao

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                         andMoney:(NSNumber *)money
                        andRemark:(NSString *)remark
                          andTime:(NSDate *)time
                andClassification:(Classification *)classsification
                       andAccount:(Account *)account
                          andShop:(Shop *)shop
                         andPhoto:(Photo *)photo
                    inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Record *record=[NSEntityDescription insertNewObjectForEntityForName:RecordEntityName
                                                 inManagedObjectContext:self.cdh.context];
    record.sid=sid;
    record.money=money;
    record.remark=remark;
    record.time=time;
    record.classification=classsification;
    record.account=account;
    record.shop=shop;
    record.photo=photo;
    record.accountBook=accountBook;
    //导入服务器数据时sync=1，默认认为它已同步
    record.sync=[NSNumber numberWithInt:SYNCED];
    [self.cdh saveContext];
    return record.objectID;
}

-(NSManagedObjectID *)synchronizeWithSid:(NSNumber *)sid
                                andMoney:(NSNumber *)money
                               andRemark:(NSString *)remark
                                 andTime:(NSDate *)time
                       andClassification:(Classification *)classsification
                              andAccount:(Account *)account
                                 andShop:(Shop *)shop
                                andPhoto:(Photo *)photo
                           inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Record *record=[NSEntityDescription insertNewObjectForEntityForName:RecordEntityName
                                                 inManagedObjectContext:self.cdh.context];
    record.sid=sid;
    record.money=money;
    record.remark=remark;
    record.time=time;
    record.classification=classsification;
    record.account=account;
    record.shop=shop;
    record.photo=photo;
    record.accountBook=accountBook;
    //同步服务器数据时sync=1，默认认为它已同步
    record.sync=[NSNumber numberWithInt:SYNCED];
    double moneyDoubleValue=money.doubleValue;
    //更新账本历史记录
    AccountHistoryDao *accountHistoryDao=[[AccountHistoryDao alloc] init];
    [accountHistoryDao updateWithMoney:moneyDoubleValue
                                onDate:[DateTool getThisDayStart:time]
                             inAccount:account];
    //更新账户、分类和商家的资金流入流出
    if(moneyDoubleValue>0) {
        record.classification.cin=[NSNumber numberWithDouble:[record.classification.cin doubleValue]+moneyDoubleValue];
        record.account.ain=[NSNumber numberWithDouble:[record.account.ain doubleValue]+moneyDoubleValue];
        record.shop.sin=[NSNumber numberWithDouble:[record.shop.sin doubleValue]+moneyDoubleValue];
    }else{
        record.classification.cout=[NSNumber numberWithDouble:[record.classification.cout doubleValue]-moneyDoubleValue];
        record.account.aout=[NSNumber numberWithDouble:[record.account.aout doubleValue]-moneyDoubleValue];
        record.shop.sout=[NSNumber numberWithDouble:[record.shop.sout doubleValue]-moneyDoubleValue];
    }
    [self.cdh saveContext];
    return record.objectID;
}

-(NSManagedObjectID *)saveWithMoney:(NSNumber *)money
                          andRemark:(NSString *)remark
                            andTime:(NSDate *)time
                  andClassification:(Classification *)classsification
                         andAccount:(Account *)account
                            andShop:(Shop *)shop
                           andPhoto:(Photo *)photo
                      inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Record *record=[NSEntityDescription insertNewObjectForEntityForName:RecordEntityName
                                                 inManagedObjectContext:self.cdh.context];
    record.money=money;
    record.remark=remark;
    record.time=time;
    record.classification=classsification;
    record.account=account;
    record.shop=shop;
    record.photo=photo;
    record.accountBook=accountBook;
    double moneyDoubleValue=money.doubleValue;
    //更新账本历史记录
    AccountHistoryDao *accountHistoryDao=[[AccountHistoryDao alloc] init];
    [accountHistoryDao updateWithMoney:moneyDoubleValue
                                onDate:[DateTool getThisDayStart:time]
                             inAccount:account];
    //更新账户、分类和商家的资金流入流出
    if(moneyDoubleValue>0) {
        record.classification.cin=[NSNumber numberWithDouble:[record.classification.cin doubleValue]+moneyDoubleValue];
        record.account.ain=[NSNumber numberWithDouble:[record.account.ain doubleValue]+moneyDoubleValue];
        record.shop.sin=[NSNumber numberWithDouble:[record.shop.sin doubleValue]+moneyDoubleValue];
    }else{
        record.classification.cout=[NSNumber numberWithDouble:[record.classification.cout doubleValue]-moneyDoubleValue];
        record.account.aout=[NSNumber numberWithDouble:[record.account.aout doubleValue]-moneyDoubleValue];
        record.shop.sout=[NSNumber numberWithDouble:[record.shop.sout doubleValue]-moneyDoubleValue];
    }
    [self.cdh saveContext];
    return record.objectID;
}

-(NSArray *)findByAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"time"
                                        ascending:NO];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"accountBook=%@",accountBook];
    return [self findByPredicate:predicate
                  withEntityName:RecordEntityName
                         orderBy:sort];
}

-(NSArray *)findNotSyncByUser:(User *)user {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSMutableArray *notSyncRecords=[[NSMutableArray alloc] init];
    for(AccountBook *accountBook in user.accountBooks) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"accountBook=%@ and sync=%d",accountBook,NOT_SYNC];
        NSArray *records=[self findByPredicate:predicate
                                withEntityName:RecordEntityName];
        [notSyncRecords addObjectsFromArray:records];
    }
    return notSyncRecords;
}


-(NSArray *)findByAccountBook:(AccountBook *)accountBook
                         from:(NSDate *)start
                           to:(NSDate *)end {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:RecordEntityName];
    request.sortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time"
                                                                                   ascending:NO]];
    request.predicate=[NSPredicate predicateWithFormat:@"time>=%@ and time<=%@ and accountBook=%@",start,end,accountBook];
    NSError *error=nil;
    NSArray *records=[self.cdh.context executeFetchRequest:request error:&error];
    if(error)
        NSLog(@"Error: %@",error);
    return records;
}

-(NSArray *)findByAccount:(Account *)account
                   onDate:(NSDate *)date {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSDate *start=[DateTool getThisDayStart:date];
    NSDate *end=[DateTool getThisDayEnd:date];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"time>=%@ and time<=%@ and account=%@",start,end,account];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"time"
                                                         ascending:YES];
    return [self findByPredicate:predicate
                  withEntityName:RecordEntityName
                         orderBy:sort];
}

-(NSArray *)getMonthlyStatisticalDataFrom:(NSDate *)start
                                       to:(NSDate *)end
                            inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSArray *records=[self findByAccountBook:accountBook from:start to:end];
    NSMutableArray *datas=[[NSMutableArray alloc] init];
    int month=0;
    int count=0;
    RecordMonthlyStatisticalData *data=nil;
    for(Record *record in records) {
        NSDateComponents *components=[DateTool getDateComponents:record.time];
        double money=[record.money doubleValue];
        if(count==0) {
            month=(int)components.month;
            data=[[RecordMonthlyStatisticalData alloc] init];
            data.date=record.time;

        }
        if(components.month==month) {
            if(money>0)
                data.earn+=money;
            else
                data.spend-=money;
        }else{
            [datas addObject:data];
            month=(int)components.month;
            data=[[RecordMonthlyStatisticalData alloc] initWithDate:record.time
                                                           andMoney:money];
        }
        //如果是最后一个对象，必须将data放入datas
        if(count==records.count-1)
            [datas addObject:data];
        count++;
    }
    return datas;
}

-(Record *)getLatestRecordInAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSSortDescriptor *sortDescriptors=[NSSortDescriptor sortDescriptorWithKey:@"time"
                                                                    ascending:NO];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"accountBook=%@",accountBook];
    return (Record *)[self getByPredicate:predicate
                           withEntityName:RecordEntityName
                                  orderBy:sortDescriptors];
}

-(double)getTotalSpendFrom:(NSDate *)start
                        to:(NSDate *)end
             inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    double totalSpend=0.0;
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:RecordEntityName];
    request.predicate=[NSPredicate predicateWithFormat:@"time>=%@ and time<=%@ and accountBook=%@ and money<=0",start,end,accountBook];
    NSError *error;
    NSArray *records=[self.cdh.context executeFetchRequest:request error:&error];
    if(error)
        NSLog(@"Error:%@",error);
    for(Record *record in records)
        totalSpend+=[record.money doubleValue];
    return totalSpend;
}

-(double)getTotalEarnFrom:(NSDate *)start
                       to:(NSDate *)end
            inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    double totalEarn=0.0;
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:RecordEntityName];
    request.predicate=[NSPredicate predicateWithFormat:@"time>=%@ and time<=%@ and accountBook=%@ and money>0",start,end,accountBook];
    NSError *error;
    NSArray *records=[self.cdh.context executeFetchRequest:request error:&error];
    if(error)
        NSLog(@"Error:%@",error);
    for(Record *record in records)
        totalEarn+=[record.money doubleValue];
    return totalEarn;
}
@end
