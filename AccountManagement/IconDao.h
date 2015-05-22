//
//  IconDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/4/26.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "Icon.h"
#import "User.h"

#define IconTypeSystemNull -1
#define IconTypeAccountBook 0
#define IconTypeAccount 1
#define IconTypeClassification 2
#define IconTypeShop 3

#define IconEntityName @"Icon"

@interface IconDao : DaoTemplate

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                          andType:(NSNumber *)type
                          andData:(NSData *)idata;

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                          andType:(NSNumber *)type
                          andData:(NSData *)idata
                          andUser:(User *)user;

-(Icon *)getBySid:(NSNumber *)sid;

-(NSArray *)findByType:(NSUInteger)type;

@end
