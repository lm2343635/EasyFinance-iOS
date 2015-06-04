//
//  SynchronizationHistoryData.h
//  AccountManagement
//
//  Created by 李大爷 on 15/6/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaoManager.h"

@interface SynchronizationHistoryData : NSObject

@property (nonatomic) int shid;
@property (nonatomic) long long timeInterval;
@property (nonatomic,retain) NSString *device;
@property (nonatomic,retain) NSString *ip;
@property (nonatomic) int uid;

-(instancetype)initWithSynchronizationHistory:(SynchronizationHistory *)history;

@end
