//
//  PhotoDao.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/3.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "PhotoDao.h"

@implementation PhotoDao

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid andData:(NSData *)pdata {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Photo *photo=[NSEntityDescription insertNewObjectForEntityForName:PhotoEntityName
                                               inManagedObjectContext:self.cdh.context];
    photo.sid=sid;
    photo.pdata=pdata;
    photo.upload=[NSDate date];
    //导入服务器数据时sync=1，默认认为它已同步
    photo.sync=[NSNumber numberWithInt:SYNCED];
    [self.cdh saveContext];
    return photo.objectID;
}

-(NSManagedObjectID *)saveWithData:(NSData *)pdata inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Photo *photo=[NSEntityDescription insertNewObjectForEntityForName:PhotoEntityName
                                               inManagedObjectContext:self.cdh.context];
    photo.pdata=pdata;
    photo.upload=[NSDate date];
    photo.accountBook=accountBook;
    [self.cdh saveContext];
    return photo.objectID;
}

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                        andUpload:(NSDate *)upload
                    inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Photo *photo=[NSEntityDescription insertNewObjectForEntityForName:PhotoEntityName
                                               inManagedObjectContext:self.cdh.context];
    photo.sid=sid;
    photo.upload=upload;
    photo.accountBook=accountBook;
    [self.cdh saveContext];
    return photo.objectID;
}

-(Photo *)getBySid:(NSNumber *)sid {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"sid=%@",sid];
    return (Photo *)[self getByPredicate:predicate withEntityName:PhotoEntityName];
}

-(NSArray *)findNotSyncByUser:(User *)user {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSMutableArray *notSyncPhotos=[[NSMutableArray alloc] init];
    for(AccountBook *accountBook in user.accountBooks) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"accountBook=%@ and sync=%@",accountBook,NOT_SYNC];
        NSArray *photos=[self findByPredicate:predicate
                               withEntityName:PhotoEntityName];
        [notSyncPhotos addObjectsFromArray:photos];
    }
    return notSyncPhotos;
}

@end
