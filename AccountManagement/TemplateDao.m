//
//  TemplateDao.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/4.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "TemplateDao.h"

@implementation TemplateDao

-(NSManagedObjectID *)saveWithAccountBook:(AccountBook *)accountBook
                                 andTpname:(NSString *)tpname
                        andClassification:(Classification *)classification
                               andAccount:(Account *)account
                                  andShop:(Shop *)shop {
    if(DEBUG==1)
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

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                        andTpname:(NSString *)tpname
                andClassification:(Classification *)classification
                       andAccount:(Account *)account
                          andShop:(Shop *)shop
                    inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Template *template=[NSEntityDescription insertNewObjectForEntityForName:TemplateEntityName
                                                     inManagedObjectContext:self.cdh.context];
    template.sid=sid;
    template.accountBook=accountBook;
    template.tpname=tpname;
    template.classification=classification;
    template.account=account;
    template.shop=shop;
    [self.cdh saveContext];
    return template.objectID;
}

@end
