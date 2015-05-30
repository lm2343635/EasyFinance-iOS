//
//  TemplateDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/4.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "Template.h"
#import "User.h"

#define TemplateEntityName @"Template"

@interface TemplateDao : DaoTemplate
//导入服务器数据使用
-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                        andTpname:(NSString *)tpname
                andClassification:(Classification *)classification
                       andAccount:(Account *)account
                          andShop:(Shop *)shop
                    inAccountBook:(AccountBook *)accountBook;

//iOS客户端新建模板使用
-(NSManagedObjectID *)saveWithAccountBook:(AccountBook *)accountBook
                                andTpname:(NSString *)tpname
                        andClassification:(Classification *)classification
                               andAccount:(Account *)account
                                  andShop:(Shop *)shop;



//得到指定账本下的所有模板，并按模板名称排序
-(NSArray *)findByAccountBook:(AccountBook *)accountBook;

//得到指定用户下的所有未同步模板
-(NSArray *)findNotSyncByUser:(User *)user;
@end
