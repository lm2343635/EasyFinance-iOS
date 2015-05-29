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
    if(DEBUG==1)
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
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Classification *classification=[NSEntityDescription insertNewObjectForEntityForName:ClassificationEntityName
                                                                 inManagedObjectContext:self.cdh.context];
    classification.accountBook=accountBook;
    classification.cname=cname;
    classification.cicon=icon;
    classification.cin=0;
    classification.cout=0;
    [self.cdh saveContext];
    return classification.objectID;
}

-(Classification *)getBySid:(NSNumber *)sid {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"sid=%@",sid];
    return (Classification *)[self getByPredicate:predicate withEntityName:ClassificationEntityName];
}
@end
