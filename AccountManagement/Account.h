//
//  Account.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/28.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccountBook, Icon;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSNumber * ain;
@property (nonatomic, retain) NSString * aname;
@property (nonatomic, retain) NSNumber * aout;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSNumber * sync;
@property (nonatomic, retain) AccountBook *accountBook;
@property (nonatomic, retain) Icon *aicon;

@end
