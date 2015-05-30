//
//  AccountHistoryDao.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/27.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AccountHistoryDao.h"
#import "RecordDao.h"
#import "TransferDao.h"
#import "DateTool.h"

@implementation AccountHistoryDao

-(NSManagedObjectID *)saveBySid:(NSNumber *)sid
                         andAin:(NSNumber *)ain
                        andAout:(NSNumber *)aout
                         onDate:(NSDate *)date
                      inAccount:(Account *)account {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    AccountHistory *accountHistory=[NSEntityDescription insertNewObjectForEntityForName:AccountHistoryEntityName
                                                                 inManagedObjectContext:self.cdh.context];
    accountHistory.sid=sid;
    accountHistory.ain=ain;
    accountHistory.aout=aout;
    accountHistory.date=date;
    accountHistory.account=account;
    //导入服务器数据时sync=1，默认认为它已同步
    accountHistory.sync=[NSNumber numberWithInt:SYNCED];
    return accountHistory.objectID;
}

-(NSArray *)findByAccount:(Account *)account
                     from:(NSDate *)start
                       to:(NSDate *)end {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:AccountHistoryEntityName];
    request.sortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                                   ascending:YES]];
//    request.predicate=[NSPredicate predicateWithFormat:@"date>=%@ and date<=%@ and account=%@",start,end,account];
    request.predicate=[NSPredicate predicateWithFormat:@"account=%@",account];
    NSError *error=nil;
    NSArray *histories=[self.cdh.context executeFetchRequest:request
                                                       error:&error];
    if(error)
        NSLog(@"Error: %@",error);
    return histories;
}

-(NSArray *)findNotSyncByUser:(User *)user {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSMutableArray *notSyncAccountHistories=[[NSMutableArray alloc] init];
    for(AccountBook *accountBook in user.accountBooks) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"accountBook=%@ and sync=%d",accountBook,NOT_SYNC];
        NSArray *accountHistories=[self findByPredicate:predicate
                                         withEntityName:AccountHistoryEntityName];
        [notSyncAccountHistories addObjectsFromArray:accountHistories];
    }
    return notSyncAccountHistories;
}

-(NSManagedObjectID *)updateWithMoney:(double)money
                               onDate:(NSDate *)date
                            inAccount:(Account *)account {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    RecordDao *recordDao=[[RecordDao alloc] init];
    TransferDao *transferDao=[[TransferDao alloc] init];
    AccountHistory *history=[self getOnDate:date inAccount:account];
    //当该日历史记录为空，直接添加新的历史记录。
    if(history==nil) {
        history=[NSEntityDescription insertNewObjectForEntityForName:AccountHistoryEntityName
                                              inManagedObjectContext:self.cdh.context];
        history.account=account;
        history.date=date;
        //如果本日的记录是第一条记录
        if([self isFirstHistory:history]) {
            //情况1：该账户不存在任何历史记录。
            //并且还是最后一条记录，说明该账户不存在任何历史记录，直接创建该条历史记录，因为该记录是该账户的首条记录。
            if([self isLastHistory:history]) {
                if (money>0) {
                    history.ain=[NSNumber numberWithDouble:money+account.ain.doubleValue];
                    history.aout=account.aout;
                } else {
                    history.ain=account.ain;
                    history.aout=[NSNumber numberWithDouble:account.aout.doubleValue-money];
                }
                NSLog(@"aout:%@ ain:%@",history.aout,history.ain);
            }
            //情况2：该账户存在历史记录，但本日记录是该账户最早的记录
            //该条记录由距离当前记录最近的之后的那一天的记录生成
            else {
                AccountHistory *latest=[self getLatestHitoryAfterDate:date
                                                            inAccount:account];
                history.aout=latest.aout;
                history.ain=latest.ain;
                //查询当前记录最近的之后的那一天的所有收支记录和转账记录
                //我们要根据这些记录还原账户的原始信息
                NSArray *records=[recordDao findByAccount:account onDate:latest.date];
                for(Record *record in records) {
                    //record.money为正说明该条收入记录应该被减去
                    if(record.money.doubleValue>0)
                        history.ain=[NSNumber numberWithDouble:history.ain.doubleValue-record.money.doubleValue];
                    //否则说明该条支出记录应该被减去，money为负！！
                    else
                        history.aout=[NSNumber numberWithDouble:history.aout.doubleValue+record.money.doubleValue];
                }
                //查询这一天所有该账户为转入账户的转账记录
                NSArray *tfins=[transferDao findByTfin:account onDate:latest.date];
                //转入的金额应该在ain中被减去
                for(Transfer *tfin in tfins)
                    history.ain=[NSNumber numberWithDouble:history.ain.doubleValue-tfin.money.doubleValue];
                //查询这一天所有该账户为转出账户的转账记录
                NSArray *tfouts=[transferDao findByTfout:account onDate:latest.date];
                //转出金额应该在aout中被减去
                for(Transfer *tfout in tfouts)
                    history.aout=[NSNumber numberWithDouble:history.aout.doubleValue-tfout.money.doubleValue];
                //到此为止，记录已经被还原，应该把本次的记录添加进去了~
                if(money>0)
                    history.ain=[NSNumber numberWithDouble:history.ain.doubleValue+money];
                else
                    history.aout=[NSNumber numberWithDouble:history.aout.doubleValue-money];
                //之后的每一条记录都将受到影响
                NSArray *histories=[self findByAccount:account fromDate:date];
                for(AccountHistory *history in histories) {
                    if(money>0)
                        history.ain=[NSNumber numberWithDouble:history.ain.doubleValue+money];
                    else
                        history.aout=[NSNumber numberWithDouble:history.aout.doubleValue-money];
                }
            }
        }
        //情况3：该账户存在历史记录，但在该日期下不存在历史记录，且该日期的记录是最后一条历史记录，需要新建一条账户历史记录。
        //否则说明在该记录之前有其他记录存在，要找到距离当前记录最近的之前的那一天的记录，并在此之上。
        //直接添加的原因是：在本次修改和latest之间不可能有其他的修改，否则在本次修改的日期就会存在一条账户历史记录。
        else {
            AccountHistory *latest=[self getLatestHitoryBeforeDate:date
                                                         inAccount:account];
            if(money>0) {
                history.ain=[NSNumber numberWithDouble:latest.ain.doubleValue+money];
                history.aout=latest.aout;
            }else{
                history.ain=latest.ain;
                history.aout=[NSNumber numberWithDouble:latest.aout.doubleValue-money];
            }
            //情况4：该账户存在历史记录，但在该日期下不存在历史记录，且该日期前后都有历史记录
            //该日期的历史记录将会同时受之前历史记录的影响，并且将会影响之后的历史记录
            if(![self isLastHistory:history]) {
                NSArray *histories=[self findByAccount:account
                                              fromDate:date];
                for(AccountHistory *history in histories) {
                    if(money>0)
                        history.ain=[NSNumber numberWithDouble:history.ain.doubleValue+money];
                    else
                        history.aout=[NSNumber numberWithDouble:history.aout.doubleValue-money];
                }
            }
        }
    }
    //否则本日已有历史记录，就要修改当前的历史记录
    else {
        //情况5：本日已有历史记录，但本日之后没有历史记录
        //如果当前历史记录是该账户的最后一条历史记录，说明之前的历史记录将不会受到本次修改的影响，直接在该条记录上修改即可
        if([self isLastHistory:history]) {
            if(money>0)
                history.ain=[NSNumber numberWithDouble:history.ain.doubleValue+money];
            else
                history.aout=[NSNumber numberWithDouble:history.aout.doubleValue-money];
        }
        //情况6：本日已有历史记录，且本日之后有历史记录
        //否则说明当前历史记录之后还有其他记录，本次修改也会影响到后面的记录
        else {
            NSArray *histories=[self findByAccount:account
                                          fromDate:[NSDate dateWithTimeInterval:-24*2300 sinceDate:date]];
            for(AccountHistory *history in histories) {
                if(money>0)
                    history.ain=[NSNumber numberWithDouble:history.ain.doubleValue+money];
                else
                    history.aout=[NSNumber numberWithDouble:history.aout.doubleValue+money];
            }
        }
    }
    [self.cdh saveContext];
    return history.objectID;
}

-(AccountHistory *)getOnDate:(NSDate *)date
                   inAccount:(Account *)account {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"date=%@ and account=%@",date,account];
    return (AccountHistory *)[self getByPredicate:predicate withEntityName:AccountHistoryEntityName];
}

-(BOOL)isFirstHistory:(AccountHistory *)history {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"date<%@ and account=%@",
                            history.date,history.account];
    if([self getByPredicate:predicate withEntityName:AccountHistoryEntityName]!=nil)
        return NO;
    return YES;
}

-(BOOL)isLastHistory:(AccountHistory *)history {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"date>%@ and account=%@",
                            history.date,history.account];
    if([self getByPredicate:predicate withEntityName:AccountHistoryEntityName]!=nil)
        return NO;
    return YES;
}

//得到指定账本在指定日期之后的最近的那一个历史记录
-(AccountHistory *)getLatestHitoryAfterDate:(NSDate *)date
                                   inAccount:(Account *)account {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"date>%@ and account=%@",date,account];
    NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                   ascending:YES];
    return (AccountHistory *)[self getByPredicate:predicate
                                   withEntityName:AccountHistoryEntityName
                                          orderBy:sortDescriptor];
}

//得到指定账本在指定日期之前的最近的那一个历史记录
-(AccountHistory *)getLatestHitoryBeforeDate:(NSDate *)date
                                    inAccount:(Account *)account {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"date<%@ and account=%@",date,account];
    NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                   ascending:NO];
    return (AccountHistory *)[self getByPredicate:predicate
                                   withEntityName:AccountHistoryEntityName
                                          orderBy:sortDescriptor];
}

//得到指定账本在指定日期之后的所有历史记录
-(NSArray *)findByAccount:(Account *)account
                 fromDate:(NSDate *)startDate {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSDate *start=[DateTool getThisDayEnd:startDate];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"date>%@ and account=%@",start,account];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                         ascending:YES];
    return [self findByPredicate:predicate
                  withEntityName:AccountHistoryEntityName
                         orderBy:sort];
}

@end
