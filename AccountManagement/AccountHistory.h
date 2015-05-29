//
//  AccountHistory.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/28.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account;

@interface AccountHistory : NSManagedObject

@property (nonatomic, retain) NSNumber * ain;
@property (nonatomic, retain) NSNumber * aout;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSNumber * sync;
@property (nonatomic, retain) Account *account;

@end
