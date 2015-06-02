//
//  Record.h
//  AccountManagement
//
//  Created by 李大爷 on 15/6/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, AccountBook, Classification, Photo, Shop;

@interface Record : NSManagedObject

@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSNumber * sync;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) AccountBook *accountBook;
@property (nonatomic, retain) Classification *classification;
@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) Shop *shop;

@end
