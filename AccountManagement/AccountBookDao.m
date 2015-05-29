//
//  AccountBookDao.m
//  AccountManagement
//
//  Created by 李大爷 on 15/4/26.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AccountBookDao.h"

@implementation AccountBookDao

-(NSManagedObjectID *)saveWithName:(NSString *)abname
                           andIcon:(Icon *)abicon {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    AccountBook *accountBook=[NSEntityDescription insertNewObjectForEntityForName:AccountBookEntityName
                                                             inManagedObjectContext:self.cdh.context];
    accountBook.abname=abname;
    accountBook.abicon=abicon;
    [self.cdh saveContext];
    return accountBook.objectID;
}

-(NSManagedObjectID *)saveWithName:(NSString *)abname
                           andIcon:(Icon *)abicon
                           andUser:(User *)user {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    AccountBook *accountBook=[NSEntityDescription insertNewObjectForEntityForName:AccountBookEntityName
                                                           inManagedObjectContext:self.cdh.context];
    accountBook.abname=abname;
    accountBook.abicon=abicon;
    accountBook.user=user;
    [self.cdh saveContext];
    return accountBook.objectID;
}

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                          andName:(NSString *)abname
                          andIcon:(Icon *)abicon
                          andUser:(User *)user {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    AccountBook *accountBook=[NSEntityDescription insertNewObjectForEntityForName:AccountBookEntityName
                                                           inManagedObjectContext:self.cdh.context];
    accountBook.abname=abname;
    accountBook.abicon=abicon;
    accountBook.user=user;
    accountBook.sid=sid;
    //导入服务器数据时sync=1，默认认为它已同步
    accountBook.sync=[NSNumber numberWithInt:SYNCED];
    [self.cdh saveContext];
    return accountBook.objectID;
}

-(AccountBook *)getBySid:(NSNumber *)sid {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"sid=%@",sid];
    return (AccountBook *)[self getByPredicate:predicate
                                withEntityName:AccountBookEntityName];
}

-(NSArray *)findByUser:(User *)user {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"user=%@",user];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"abname"
                                                         ascending:YES];
    return [self findByPredicate:predicate
                  withEntityName:AccountBookEntityName
                         orderBy:sort];
}

-(NSArray *)findNotSyncByUser:(User *)user {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"sync=%d and user=%@",NOT_SYNC,user];
    return [self findByPredicate:predicate
                  withEntityName:AccountBookEntityName];
}

@end
