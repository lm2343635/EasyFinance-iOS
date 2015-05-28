//
//  DaoManager.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/4.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoManager.h"

@implementation DaoManager

-(id)init {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    self=[super init];
    self.accountBookDao=[[AccountBookDao alloc] init];
    self.accountDao=[[AccountDao alloc] init];
    self.classificationDao=[[ClassificationDao alloc] init];
    self.iconDao=[[IconDao alloc] init];
    self.photoDao=[[PhotoDao alloc] init];
    self.shopDao=[[ShopDao alloc] init];
    self.userDao=[[UserDao alloc] init];
    self.recordDao=[[RecordDao alloc] init];
    self.transferDao=[[TransferDao alloc] init];
    self.templateDao=[[TemplateDao alloc] init];
    self.accountHistoryDao=[[AccountHistoryDao alloc] init];
    self.cdh=[(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    return self;
}

-(NSManagedObject *)getObjectById:(NSManagedObjectID *)objectID {
    return [self.cdh.context existingObjectWithID:objectID error:nil];
}
@end
