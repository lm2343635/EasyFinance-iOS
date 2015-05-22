//
//  CoreDataHelper.h
//  AccountManagement
//
//  Created by 李大爷 on 15/4/24.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

//数据文件存储文件名
#define StoreFileName @"AccountManagement.sqlite"

@interface CoreDataHelper : NSObject<NSXMLParserDelegate>

@property (nonatomic,readonly) NSManagedObjectContext *context;
@property (nonatomic,readonly) NSManagedObjectModel *model;
@property (nonatomic,readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic,readonly) NSPersistentStore *store;

@property (nonatomic,readonly) NSManagedObjectContext *importContext;

@property (nonatomic,strong) NSXMLParser *parser;

-(void)setupCoreData;
-(void)saveContext;

@end
