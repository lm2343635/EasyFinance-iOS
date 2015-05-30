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
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Account *account=[NSEntityDescription insertNewObjectForEntityForName:AccountEntityName
                                                   inManagedObjectContext:self.cdh.context];
    account.sid=sid;
    account.aname=aname;
    account.aicon=aicon;
    account.ain=ain;
    account.aout=aout;
    account.accountBook=accountBook;
    //导入服务器数据时sync=1，默认认为它已同步
    account.sync=[NSNumber numberWithInt:SYNCED];
    [self.cdh saveContext];
    return account.objectID;
}

-(NSManagedObjectID *)saveWithAccountBook:(AccountBook *)accountBook
                                 andAname:(NSString *)aname
                                 andAicon:(Icon *)aicon
                                   andAin:(NSNumber *)ain {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Account *account=[NSEntityDescription insertNewObjectForEntityForName:AccountEntityName
                                                   inManagedObjectContext:self.cdh.context];
    account.accountBook=accountBook;
    account.aname=aname;
    account.aicon=aicon;
    account.ain=ain;
    [self.cdh saveContext];
    return account.objectID;
}

-(Account *)getBySid:(NSNumber *)sid {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"sid=%@",sid];
    return (Account *)[self getByPredicate:predicate withEntityName:AccountEntityName];
}

-(AccountInformation *)getAccountInformationInAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:AccountEntityName];
    request.predicate=[NSPredicate predicateWithFormat:@"accountBook=%@",accountBook];
    NSError *error=nil;
    NSArray *accounts=[self.cdh.context executeFetchRequest:request error:&error];
    if(error)
        NSLog(@"Error: %@",error);
    AccountInformation *information=[[AccountInformation alloc] init];
    for(Account *account in accounts) {
        double surplus=account.ain.doubleValue-account.aout.doubleValue;
        if(surplus>0)
            information.totalAssets+=surplus;
        else
            information.totaLibilities-=surplus;
    }
    information.netAssets=information.totalAssets-information.totaLibilities;
    return information;
}

-(NSArray *)findByAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"accountBook=%@",accountBook];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"aname"
                                                         ascending:YES];
    return [self findByPredicate:predicate
                  withEntityName:AccountEntityName
                         orderBy:sort];
}

-(NSArray *)findNotSyncByUser:(User *)user {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSMutableArray *notSyncAccounts=[[NSMutableArray alloc] init];
    for(AccountBook *accountBook in user.accountBooks) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"sync=%d and accountBook=%@",NOT_SYNC,accountBook];
        NSArray *accounts=[self findByPredicate:predicate
                                 withEntityName:AccountEntityName];
        [notSyncAccounts addObjectsFromArray:accounts];
    }
    return notSyncAccounts;
}
@end
