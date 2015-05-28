//
//  IconDao.m
//  AccountManagement
//
//  Created by 李大爷 on 15/4/26.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "IconDao.h"

@implementation IconDao

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                          andType:(NSNumber *)type
                          andData:(NSData *)idata {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Icon *icon=[NSEntityDescription insertNewObjectForEntityForName:IconEntityName
                                                                 inManagedObjectContext:self.cdh.context];
    icon.sid=sid;
    icon.idata=idata;
    icon.type=type;
    [self.cdh saveContext];
    return icon.objectID;
}

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                          andType:(NSNumber *)type
                          andData:(NSData *)idata
                          andUser:(User *)user {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Icon *icon=[NSEntityDescription insertNewObjectForEntityForName:IconEntityName
                                             inManagedObjectContext:self.cdh.context];
    icon.sid=sid;
    icon.idata=idata;
    icon.type=type;
    icon.user=user;
    [self.cdh saveContext];
    return icon.objectID;
}

-(Icon *)getBySid:(NSNumber *)sid {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"sid=%@",sid];
    return (Icon *)[self getByPredicate:predicate withEntityName:IconEntityName];
}

-(NSArray *)findByType:(NSUInteger)type {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"Icon"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"type=%d",type];
    [request setPredicate:predicate];
    NSError *error=nil;
    NSArray *accountBookIcons=[self.cdh.context executeFetchRequest:request error:&error];
    if(error)
        NSLog(@"%@",error);
    return accountBookIcons;
}

@end
