//
//  Photo.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/3.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccountBook;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSData * pdata;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSDate * upload;
@property (nonatomic, retain) AccountBook *accountBook;

@end
