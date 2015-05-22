//
//  Shop.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/3.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccountBook, Icon;

@interface Shop : NSManagedObject

@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSNumber * sin;
@property (nonatomic, retain) NSString * sname;
@property (nonatomic, retain) NSNumber * sout;
@property (nonatomic, retain) AccountBook *accountBook;
@property (nonatomic, retain) Icon *sicon;

@end
