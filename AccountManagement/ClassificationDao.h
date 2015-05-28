//
//  ClassificationDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "Classification.h"

#define ClassificationEntityName @"Classification"

@interface ClassificationDao : DaoTemplate

//导入服务器数据时使用
-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                         andCname:(NSString *)cname
                         andCicon:(Icon *)cicon
                           andCin:(NSNumber *)cin
                          andCout:(NSNumber *)cout
                    inAccountBook:(AccountBook *)accountBook;

//客户端新建时使用,客户端新建时cin和cout一定为0
-(NSManagedObjectID *)saveWithAccountBook:(AccountBook *)accountBook
                                 andCname:(NSString *)cname
                                 andCicon:(Icon *)icon;

-(Classification *)getBySid:(NSNumber *)sid;

@end
