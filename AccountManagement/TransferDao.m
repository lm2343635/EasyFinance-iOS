//
//  TransferDao.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/4.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "TransferDao.h"
#import "DateTool.h"
#import "TransferMonthlyStatisticalData.h"

#define TransferEntityName @"Transfer"

@implementation TransferDao

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                         andMoney:(NSNumber *)money
                        andRemark:(NSString *)remark
                          andTime:(NSDate *)time
                    andOutAccount:(Account *)tfout
                     andInAccount:(Account *)tfin
                    inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Transfer *transfer=[NSEntityDescription insertNewObjectForEntityForName:TransferEntityName
                                                     inManagedObjectContext:self.cdh.context];
    transfer.sid=sid;
    transfer.money=money;
    transfer.remark=remark;
    transfer.time=time;
    transfer.tfin=tfin;
    transfer.tfout=tfout;
    transfer.accountBook=accountBook;
    //导入服务器数据时sync=1，默认认为它已同步
    transfer.sync=[NSNumber numberWithInt:SYNCED];
    [self.cdh saveContext];
    return transfer.objectID;
}

-(NSManagedObjectID *)saveWithMoney:(NSNumber *)money
                          andRemark:(NSString *)remark
                            andTime:(NSDate *)time
                      andOutAccount:(Account *)tfout
                       andInAccount:(Account *)tfin
                      inAccountBook:(AccountBook *)accountBook{
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Transfer *transfer=[NSEntityDescription insertNewObjectForEntityForName:TransferEntityName
                                                     inManagedObjectContext:self.cdh.context];
    transfer.money=money;
    transfer.remark=remark;
    transfer.time=time;
    transfer.tfin=tfin;
    transfer.tfout=tfout;
    transfer.accountBook=accountBook;
    //更新账户的资金流入流出
    double moneyDoubleValue=money.doubleValue;
    transfer.tfin.ain=[NSNumber numberWithDouble:transfer.tfin.ain.doubleValue+moneyDoubleValue];
    transfer.tfout.aout=[NSNumber numberWithDouble:transfer.tfout.aout.doubleValue+moneyDoubleValue];
    [self.cdh saveContext];
    return transfer.objectID;
}

-(NSArray *)findNotSyncByUser:(User *)user {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSMutableArray *notSyncTransfers=[[NSMutableArray alloc] init];
    for(AccountBook *accountBook in user.accountBooks) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"accountBook=%@ and sync=%d",accountBook,NOT_SYNC];
        NSArray *transfers=[self findByPredicate:predicate
                                  withEntityName:TransferEntityName];
        [notSyncTransfers addObjectsFromArray:transfers];
    }
    return notSyncTransfers;
}

-(NSArray *)findByAccountBook:(AccountBook *)accountBook
                         from:(NSDate *)start
                           to:(NSDate *)end {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:TransferEntityName];
    request.sortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time"
                                                                                   ascending:NO]];
    request.predicate=[NSPredicate predicateWithFormat:@"time>=%@ and time<=%@ and accountBook=%@",start,end,accountBook];
    NSError *error=nil;
    NSArray *transfers=[self.cdh.context executeFetchRequest:request error:&error];
    if(error)
        NSLog(@"Error: %@",error);
    return transfers;
}

-(NSArray *)getMonthlyStatisticalDataFrom:(NSDate *)start
                                       to:(NSDate *)end
                            inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSArray *transfers=[self findByAccountBook:accountBook from:start to:end];
    NSMutableArray *datas=[[NSMutableArray alloc] init];
    int month=0,count=0;
    TransferMonthlyStatisticalData *data=nil;
    for(Transfer *transfer in transfers) {
        NSDateComponents *components=[DateTool getDateComponents:transfer.time];
        double money=[transfer.money doubleValue];
        if(count==0) {
            month=(int)components.month;
            data=[[TransferMonthlyStatisticalData alloc] init];
            data.date=transfer.time;
        }
        if(components.month==month)
            data.amount+=money;
        else {
            [datas addObject:data];
            month=(int)components.month;
            data=[[TransferMonthlyStatisticalData alloc] init];
            data.date=transfer.time;
            data.amount=money;
        }
        //如果是最后一个对象，必须将data放入datas
        if(count==transfers.count-1)
            [datas addObject:data];
        count++;
    }
    return datas;
}

-(NSArray *)findByTfin:(Account *)tfin
                onDate:(NSDate *)date {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSDate *start=[DateTool getThisDayStart:date];
    NSDate *end=[DateTool getThisDayEnd:date];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"time>=%@ and time<=%@ and tfin=%@",start,end,tfin];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"time"
                                                         ascending:YES];
    return [self findByPredicate:predicate
                  withEntityName:TransferEntityName
                         orderBy:sort];
}

-(NSArray *)findByTfout:(Account *)tfout
                 onDate:(NSDate *)date {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSDate *start=[DateTool getThisDayStart:date];
    NSDate *end=[DateTool getThisDayEnd:date];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"time>=%@ and time<=%@ and tfout=%@",start,end,tfout];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"time"
                                                         ascending:YES];
    return [self findByPredicate:predicate
                  withEntityName:TransferEntityName
                         orderBy:sort];
}

@end
