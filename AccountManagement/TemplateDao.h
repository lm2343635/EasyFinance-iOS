//
//  TemplateDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/4.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "Template.h"

#define TemplateEntityName @"Template"

@interface TemplateDao : DaoTemplate

-(NSManagedObjectID *)saveWithAccountBook:(AccountBook *)accountBook
                                andTpname:(NSString *)tpname
                        andClassification:(Classification *)classification
                               andAccount:(Account *)account
                                  andShop:(Shop *)shop;

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                        andTpname:(NSString *)tpname
                andClassification:(Classification *)classification
                       andAccount:(Account *)account
                          andShop:(Shop *)shop
                    inAccountBook:(AccountBook *)accountBook;
@end
