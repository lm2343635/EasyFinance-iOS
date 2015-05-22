//
//  Classification.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/3.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccountBook, Icon;

@interface Classification : NSManagedObject

@property (nonatomic, retain) NSNumber * cin;
@property (nonatomic, retain) NSString * cname;
@property (nonatomic, retain) NSNumber * cout;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) AccountBook *accountBook;
@property (nonatomic, retain) Icon *cicon;

@end
