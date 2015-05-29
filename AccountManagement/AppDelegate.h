//
//  AppDelegate.h
//  AccountManagement
//
//  Created by 李大爷 on 14/12/6.
//  Copyright (c) 2014年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "AFHTTPRequestOperationManager.h"

#define DEBUG 1
#define APP_DELEGATE_DEBUG 0
#define CELL_AT_INDEX_PATH_DEBUG 0

#define SYNCED 1
#define NOT_SYNC 0
#define SYNC_DELATE -1

#define KeyboardHeight 290.0

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong,readonly) CoreDataHelper *coreDataHelper;
@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

-(CoreDataHelper *)cdh;
@end

