//
//  Transfer.h
//  AccountManagement
//
//  Created by 李大爷 on 15/6/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, AccountBook;

@interface Transfer : NSManagedObject

@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSNumber * sync;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) AccountBook *accountBook;
@property (nonatomic, retain) Account *tfin;
@property (nonatomic, retain) Account *tfout;

@end
