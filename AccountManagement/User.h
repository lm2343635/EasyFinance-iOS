//
//  User.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/3.
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
@property (nonatomic, retain) NSString * uname;
@property (nonatomic, retain) NSSet *icons;
@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) AccountBook *usingAccountBook;
@property (nonatomic, retain) NSSet *accountBooks;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addIconsObject:(Icon *)value;
- (void)removeIconsObject:(Icon *)value;
- (void)addIcons:(NSSet *)values;
- (void)removeIcons:(NSSet *)values;

- (void)addAccountBooksObject:(AccountBook *)value;
- (void)removeAccountBooksObject:(AccountBook *)value;
- (void)addAccountBooks:(NSSet *)values;
- (void)removeAccountBooks:(NSSet *)values;

@end
