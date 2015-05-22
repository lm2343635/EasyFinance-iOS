//
//  AccountBook.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/3.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, Classification, Icon, Photo, Record, Shop, Template, Transfer, User;

@interface AccountBook : NSManagedObject

@property (nonatomic, retain) NSString * abname;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) Icon *abicon;
@property (nonatomic, retain) NSSet *accounts;
@property (nonatomic, retain) NSSet *classifications;
@property (nonatomic, retain) NSOrderedSet *records;
@property (nonatomic, retain) NSSet *shops;
@property (nonatomic, retain) NSSet *templates;
@property (nonatomic, retain) NSOrderedSet *transfers;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSOrderedSet *photos;
@end

@interface AccountBook (CoreDataGeneratedAccessors)

- (void)addAccountsObject:(Account *)value;
- (void)removeAccountsObject:(Account *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

- (void)addClassificationsObject:(Classification *)value;
- (void)removeClassificationsObject:(Classification *)value;
- (void)addClassifications:(NSSet *)values;
- (void)removeClassifications:(NSSet *)values;

- (void)insertObject:(Record *)value inRecordsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRecordsAtIndex:(NSUInteger)idx;
- (void)insertRecords:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRecordsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRecordsAtIndex:(NSUInteger)idx withObject:(Record *)value;
- (void)replaceRecordsAtIndexes:(NSIndexSet *)indexes withRecords:(NSArray *)values;
- (void)addRecordsObject:(Record *)value;
- (void)removeRecordsObject:(Record *)value;
- (void)addRecords:(NSOrderedSet *)values;
- (void)removeRecords:(NSOrderedSet *)values;
- (void)addShopsObject:(Shop *)value;
- (void)removeShopsObject:(Shop *)value;
- (void)addShops:(NSSet *)values;
- (void)removeShops:(NSSet *)values;

- (void)addTemplatesObject:(Template *)value;
- (void)removeTemplatesObject:(Template *)value;
- (void)addTemplates:(NSSet *)values;
- (void)removeTemplates:(NSSet *)values;

- (void)insertObject:(Transfer *)value inTransfersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTransfersAtIndex:(NSUInteger)idx;
- (void)insertTransfers:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTransfersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTransfersAtIndex:(NSUInteger)idx withObject:(Transfer *)value;
- (void)replaceTransfersAtIndexes:(NSIndexSet *)indexes withTransfers:(NSArray *)values;
- (void)addTransfersObject:(Transfer *)value;
- (void)removeTransfersObject:(Transfer *)value;
- (void)addTransfers:(NSOrderedSet *)values;
- (void)removeTransfers:(NSOrderedSet *)values;
- (void)insertObject:(Photo *)value inPhotosAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPhotosAtIndex:(NSUInteger)idx;
- (void)insertPhotos:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePhotosAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPhotosAtIndex:(NSUInteger)idx withObject:(Photo *)value;
- (void)replacePhotosAtIndexes:(NSIndexSet *)indexes withPhotos:(NSArray *)values;
- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSOrderedSet *)values;
- (void)removePhotos:(NSOrderedSet *)values;
@end
