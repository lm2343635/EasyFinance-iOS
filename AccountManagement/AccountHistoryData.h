//
//  AccountHistoryData.h
//  AccountManagement
//
//  Created by 李大爷 on 15/6/1.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaoManager.h"

@interface AccountHistoryData : NSObject

@property (nonatomic) int ahid;
@property (nonatomic) long timeInterval;
@property (nonatomic) double aout;
@property (nonatomic) double ain;
@property (nonatomic) int aid;
@property (nonatomic) int sync;

-(instancetype)initWithAccountHistory:(AccountHistory *)accountHistory;
@end
