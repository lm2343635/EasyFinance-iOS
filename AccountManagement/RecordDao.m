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
    if(DEBUG==1)
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
    if(DEBUG==1)
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
    [self.cdh saveContext];
    return record.objectID;
}

-(NSArray *)findByAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:RecordEntityName];
    request.sortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time"
                                                                                   ascending:NO]];
    request.predicate=[NSPredicate predicateWithFormat:@"accountBook=%@",accountBook];
    NSError *error=nil;
    NSArray *records=[self.cdh.context executeFetchRequest:request error:&error];
    if(error)
        NSLog(@"Error: %@",error);
    return records;
}

-(NSArray *)findByAccountBook:(AccountBook *)accountBook
                         from:(NSDate *)start
                           to:(NSDate *)end {
    if(DEBUG==1)
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

-(NSArray *)getMonthlyStatisticalDataFrom:(NSDate *)start
                                       to:(NSDate *)end
                            inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1)
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
@end
