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
    NSString *predicate=[NSString stringWithFormat:@"sid=%@",sid];
    return (Classification *)[self getByPredicate:predicate withEntityName:ClassificationEntityName];
}
@end