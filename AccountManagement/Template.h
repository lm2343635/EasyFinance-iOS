//
//  Template.h
//  AccountManagement
//
//  Created by 李大爷 on 15/6/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, AccountBook, Classification, Shop;

@interface Template : NSManagedObject

@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSNumber * sync;
@property (nonatomic, retain) NSString * tpname;
@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) AccountBook *accountBook;
@property (nonatomic, retain) Classification *classification;
@property (nonatomic, retain) Shop *shop;

@end
