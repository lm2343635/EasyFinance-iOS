//
//  Icon.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/28.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Icon : NSManagedObject

@property (nonatomic, retain) NSData * idata;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * sync;
@property (nonatomic, retain) User *user;

@end
