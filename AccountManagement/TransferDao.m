//
//  TransferDao.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/4.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "TransferDao.h"

#define TransferEntityName @"Transfer"

@implementation TransferDao

-(NSManagedObjectID *)saveWithMoney:(NSNumber *)money
                          andRemark:(NSString *)remark
                            andTime:(NSDate *)time
                      andOutAccount:(Account *)tfout
                       andInAccount:(Account *)tfin
                      inAccountBook:(AccountBook *)accountBook{
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Transfer *transfer=[NSEntityDescription insertNewObjectForEntityForName:TransferEntityName
                                                     inManagedObjectContext:self.cdh.context];
    transfer.money=money;
    transfer.remark=remark;
    transfer.time=time;
    transfer.tfin=tfin;
    transfer.tfout=tfout;
    transfer.accountBook=accountBook;
    [self.cdh saveContext];
    return transfer.objectID;
}

@end
