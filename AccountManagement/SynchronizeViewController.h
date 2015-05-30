//
//  SynchronizeViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/29.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SynchronizeStatusIcon 0
#define SynchronizeStatusAccountBook 1
#define SynchronizeStatusClassification 2
#define SynchronizeStatusAccount 3
#define SynchronizeStatusShop 4
#define SynchronizeStatusTemplate 5
#define SynchronizeStatusPhoto 6
#define SynchronizeStatusRecord 7
#define SynchronizeStatusTransfer 8
#define SynchronizeStatusAccountHistory 9
#define SynchronizeStatusEnd 10

@interface SynchronizeViewController : UIViewController

@property (nonatomic) NSInteger synchronizaStatus;

@end
