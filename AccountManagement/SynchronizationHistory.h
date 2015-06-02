//
//  SynchronizationHistory.h
//  AccountManagement
//
//  Created by 李大爷 on 15/6/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface SynchronizationHistory : NSManagedObject

@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * ip;
@property (nonatomic, retain) NSString * device;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) User *user;

@end
