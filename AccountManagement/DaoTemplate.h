//
//  DaoTemplate.h
//  AccountManagement
//
//  Created by 李大爷 on 15/4/26.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataHelper.h"
#import "AppDelegate.h"

#define DAO_DEBUG 0

@interface DaoTemplate : NSObject

@property (nonatomic,readonly) AppDelegate *delegate;
@property (nonatomic,readonly) CoreDataHelper *cdh;

//通过谓词和实体名称查询一个托管对象
-(NSManagedObject *)getByPredicate:(NSString *)predicate
                    withEntityName:(NSString *)entityName;

@end
