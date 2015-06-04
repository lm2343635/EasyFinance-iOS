//
//  SynchronizationHistoryDao.m
//  AccountManagement
//
//  Created by 李大爷 on 15/6/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "SynchronizationHistoryDao.h"

@implementation SynchronizationHistoryDao

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                          andTime:(NSDate *)time
                            andIP:(NSString *)ip
                        andDevice:(NSString *)device
                           inUser:(User *)user {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    SynchronizationHistory *history=[NSEntityDescription insertNewObjectForEntityForName:SynchronizationHistoryEntityName
                                                                  inManagedObjectContext:self.cdh.context];
    history.sid=sid;
    history.time=time;
    history.ip=ip;
    history.device=device;
    history.user=user;
    [self.cdh saveContext];
    return history.objectID;
}

-(NSManagedObjectID *)saveWithTime:(NSDate *)time
                         andDevice:(NSString *)device
                            inUser:(User *)user {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    SynchronizationHistory *history=[NSEntityDescription insertNewObjectForEntityForName:SynchronizationHistoryEntityName
                                                                  inManagedObjectContext:self.cdh.context];
    history.time=time;
    history.device=device;
    history.user=user;
    [self.cdh saveContext];
    return history.objectID;
}

-(NSArray *)findByUser:(User *)user {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"user=%@",user];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"time"
                                                         ascending:NO];
    return [self findByPredicate:predicate
                  withEntityName:SynchronizationHistoryEntityName
                         orderBy:sort];
}

@end
