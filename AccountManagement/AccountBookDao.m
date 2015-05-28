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
    if(DEBUG==1)
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
    if(DEBUG==1)
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
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    AccountBook *accountBook=[NSEntityDescription insertNewObjectForEntityForName:AccountBookEntityName
                                                           inManagedObjectContext:self.cdh.context];
    accountBook.abname=abname;
    accountBook.abicon=abicon;
    accountBook.user=user;
    accountBook.sid=sid;
    [self.cdh saveContext];
    return accountBook.objectID;
}

-(AccountBook *)getBySid:(NSNumber *)sid {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"sid=%@",sid];
    return (AccountBook *)[self getByPredicate:predicate withEntityName:AccountBookEntityName];
}

-(NSArray *)findAll {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:AccountBookEntityName];
    //    NSPredicate *predicate=[NSPredicate predicateWithFormat:@""];
    //    [request setPredicate:predicate];
    NSError *error=nil;
    if(self.cdh==nil)
        NSLog(@"self.cdh==nil");
    NSArray *accountBooks=[self.cdh.context executeFetchRequest:request error:&error];
    NSLog(@"accountBooks.count=%ld",accountBooks.count);
    if(error)
        NSLog(@"%@",error);
    return accountBooks;
}

@end
