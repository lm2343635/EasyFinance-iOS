//
//  ClassificationDao.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "ClassificationDao.h"


@implementation ClassificationDao

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                         andCname:(NSString *)cname
                         andCicon:(Icon *)cicon
                           andCin:(NSNumber *)cin
                          andCout:(NSNumber *)cout
                    inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Classification *classification=[NSEntityDescription insertNewObjectForEntityForName:ClassificationEntityName
                                                                 inManagedObjectContext:self.cdh.context];
    classification.sid=sid;
    classification.cname=cname;
    classification.cicon=cicon;
    classification.cin=cin;
    classification.cout=cout;
    classification.accountBook=accountBook;
    //导入服务器数据时sync=1，默认认为它已同步
    classification.sync=[NSNumber numberWithInt:SYNCED];
    [self.cdh saveContext];
    return classification.objectID;
}

-(NSManagedObjectID *)saveWithAccountBook:(AccountBook *)accountBook
                                 andCname:(NSString *)cname
                                 andCicon:(Icon *)icon {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Classification *classification=[NSEntityDescription insertNewObjectForEntityForName:ClassificationEntityName
                                                                 inManagedObjectContext:self.cdh.context];
    classification.accountBook=accountBook;
    classification.cname=cname;
    classification.cicon=icon;
    [self.cdh saveContext];
    return classification.objectID;
}

-(Classification *)getBySid:(NSNumber *)sid {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"sid=%@",sid];
    return (Classification *)[self getByPredicate:predicate withEntityName:ClassificationEntityName];
}

-(NSArray *)findByAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"accountBook=%@",accountBook];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"cname"
                                                         ascending:YES];
    return [self findByPredicate:predicate
                  withEntityName:ClassificationEntityName
                         orderBy:sort];
}

-(NSArray *)findNotSyncByUser:(User *)user {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSMutableArray *notSyncClassifications=[[NSMutableArray alloc] init];
    for(AccountBook *accountBook in user.accountBooks) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"sync=%d and accountBook=%@",NOT_SYNC,accountBook];
        NSArray *classifications=[self findByPredicate:predicate
                                        withEntityName:ClassificationEntityName];
        [notSyncClassifications addObjectsFromArray:classifications];
    }
    return notSyncClassifications;
}
@end
