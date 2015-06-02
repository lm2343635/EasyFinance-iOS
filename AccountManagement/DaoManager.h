//
//  DaoManager.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/4.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountBookDao.h"
#import "AccountDao.h"
#import "ClassificationDao.h"
#import "IconDao.h"
#import "PhotoDao.h"
#import "ShopDao.h"
#import "UserDao.h"
#import "RecordDao.h"
#import "TransferDao.h"
#import "TemplateDao.h"
#import "AccountHistoryDao.h"
#import "SynchronizationHistoryDao.h"

@interface DaoManager : NSObject

@property (strong,nonatomic) AccountBookDao *accountBookDao;
@property (strong,nonatomic) AccountDao *accountDao;
@property (strong,nonatomic) ClassificationDao *classificationDao;
@property (strong,nonatomic) IconDao *iconDao;
@property (strong,nonatomic) PhotoDao *photoDao;
@property (strong,nonatomic) ShopDao *shopDao;
@property (strong,nonatomic) UserDao *userDao;
@property (strong,nonatomic) RecordDao *recordDao;
@property (strong,nonatomic) TransferDao *transferDao;
@property (strong,nonatomic) TemplateDao *templateDao;
@property (strong,nonatomic) AccountHistoryDao *accountHistoryDao;
@property (strong,nonatomic) SynchronizationHistoryDao *synchronizationHistoryDao;

@property (strong,nonatomic) CoreDataHelper *cdh;

-(NSManagedObject *)getObjectById:(NSManagedObjectID *)objectID;

@end
