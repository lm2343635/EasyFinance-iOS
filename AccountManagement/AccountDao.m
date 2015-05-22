//
//  AccountDao.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AccountDao.h"

@implementation AccountDao

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                         andAname:(NSString *)aname
                         andAicon:(Icon *)aicon
                           andAin:(NSNumber *)ain
                          andAout:(NSNumber *)aout
                    inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Account *account=[NSEntityDescription insertNewObjectForEntityForName:AccountEntityName
                                                   inManagedObjectContext:self.cdh.context];
    account.sid=sid;
    account.aname=aname;
    account.aicon=aicon;
    account.ain=ain;
    account.aout=aout;
    account.accountBook=accountBook;
    [self.cdh saveContext];
    return account.objectID;
}

-(NSManagedObjectID *)saveWithAccountBook:(AccountBook *)accountBook
                                 andAname:(NSString *)aname
                                 andAicon:(Icon *)aicon
                                   andAin:(NSNumber *)ain {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Account *account=[NSEntityDescription insertNewObjectForEntityForName:AccountEntityName
                                                   inManagedObjectContext:self.cdh.context];
    account.accountBook=accountBook;
    account.aname=aname;
    account.aicon=aicon;
    account.ain=ain;
    account.aout=0;
    [self.cdh saveContext];
    return account.objectID;
}

-(Account *)getBySid:(NSNumber *)sid {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSString *predicate=[NSString stringWithFormat:@"sid=%@",sid];
    return (Account *)[self getByPredicate:predicate withEntityName:AccountEntityName];
}

@end
