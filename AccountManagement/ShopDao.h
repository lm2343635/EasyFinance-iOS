//
//  ShopDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "Shop.h"

#define ShopEntityName @"Shop"

@interface ShopDao : DaoTemplate

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                         andSname:(NSString *)sname
                         andSicon:(Icon *)sicon
                           andSin:(NSNumber *)sin
                          andSout:(NSNumber *)sout
                    inAccountBook:(AccountBook *)accountBook;

-(NSManagedObjectID *)saveWithAccountBook:(AccountBook *)accountBook
                                 andSname:(NSString *)sname
                                 andSicon:(Icon *)sicon;

-(Shop *)getBySid:(NSNumber *)sid;

@end
