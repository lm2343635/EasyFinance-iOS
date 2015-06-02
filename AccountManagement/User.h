//
//  User.h
//  AccountManagement
//
//  Created by 李大爷 on 15/6/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccountBook, Icon, Photo;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * login;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSString * syncKey;
@property (nonatomic, retain) NSString * uname;
@property (nonatomic, retain) NSSet *accountBooks;
@property (nonatomic, retain) NSSet *icons;
@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) AccountBook *usingAccountBook;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addAccountBooksObject:(AccountBook *)value;
- (void)removeAccountBooksObject:(AccountBook *)value;
- (void)addAccountBooks:(NSSet *)values;
- (void)removeAccountBooks:(NSSet *)values;

- (void)addIconsObject:(Icon *)value;
- (void)removeIconsObject:(Icon *)value;
- (void)addIcons:(NSSet *)values;
- (void)removeIcons:(NSSet *)values;

@end
