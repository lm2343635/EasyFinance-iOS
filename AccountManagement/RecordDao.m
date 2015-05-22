//
//  RecordDao.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/4.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "RecordDao.h"

@implementation RecordDao

-(NSManagedObjectID *)saveWithMoney:(NSNumber *)money
                          andRemark:(NSString *)remark
                            andTime:(NSDate *)time
                  andClassification:(Classification *)classsification
                         andAccount:(Account *)account
                            andShop:(Shop *)shop
                           andPhoto:(Photo *)photo
                      inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Record *record=[NSEntityDescription insertNewObjectForEntityForName:RecordEntityName
                                                 inManagedObjectContext:self.cdh.context];
    record.money=money;
    record.remark=remark;
    record.time=time;
    record.classification=classsification;
    record.account=account;
    record.shop=shop;
    record.photo=photo;
    record.accountBook=accountBook;
    [self.cdh saveContext];
    return record.objectID;
}

-(NSArray *)findByAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:RecordEntityName];
    request.sortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time"
                                                                                   ascending:NO]];
    request.predicate=[NSPredicate predicateWithFormat:@"accountBook=%@",accountBook];
    NSError *error=nil;
    NSArray *records=[self.cdh.context executeFetchRequest:request error:&error];
    if(error)
        NSLog(@"Error: %@",error);
    return records;
}
@end
