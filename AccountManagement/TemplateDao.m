//
//  TemplateDao.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/4.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "TemplateDao.h"

@implementation TemplateDao

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                        andTpname:(NSString *)tpname
                andClassification:(Classification *)classification
                       andAccount:(Account *)account
                          andShop:(Shop *)shop
                    inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Template *template=[NSEntityDescription insertNewObjectForEntityForName:TemplateEntityName
                                                     inManagedObjectContext:self.cdh.context];
    template.sid=sid;
    template.accountBook=accountBook;
    template.tpname=tpname;
    template.classification=classification;
    template.account=account;
    template.shop=shop;
    //导入服务器数据时sync=1，默认认为它已同步
    template.sync=[NSNumber numberWithInt:SYNCED];
    [self.cdh saveContext];
    return template.objectID;
}

-(NSManagedObjectID *)saveWithAccountBook:(AccountBook *)accountBook
                                 andTpname:(NSString *)tpname
                        andClassification:(Classification *)classification
                               andAccount:(Account *)account
                                  andShop:(Shop *)shop {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Template *template=[NSEntityDescription insertNewObjectForEntityForName:TemplateEntityName
                                                     inManagedObjectContext:self.cdh.context];
    template.accountBook=accountBook;
    template.tpname=tpname;
    template.classification=classification;
    template.account=account;
    template.shop=shop;
    [self.cdh saveContext];
    return template.objectID;
}

-(NSArray *)findByAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"accountBook=%@",accountBook];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"tpname"
                                                         ascending:YES];
    return [self findByPredicate:predicate
                  withEntityName:TemplateEntityName
                         orderBy:sort];
}

-(NSArray *)findNotSyncByUser:(User *)user {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSMutableArray *notSyncTemplates=[[NSMutableArray alloc] init];
    for(AccountBook *accountBook in user.accountBooks) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"accountBook=%@ and sync=%d",accountBook,NOT_SYNC];
        NSArray *templates=[self findByPredicate:predicate
                                  withEntityName:TemplateEntityName];
        [notSyncTemplates addObjectsFromArray:templates];
    }
    return notSyncTemplates;
}
@end
