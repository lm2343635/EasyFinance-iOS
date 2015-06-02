//
//  SynchronizationHistoryData.m
//  AccountManagement
//
//  Created by 李大爷 on 15/6/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "SynchronizationHistoryData.h"

@implementation SynchronizationHistoryData

@synthesize shid;
@synthesize timeInterval;
@synthesize ip;
@synthesize device;
@synthesize uid;

-(instancetype)initWithSynchronizationHistory:(SynchronizationHistory *)history {
    self=[super init];
    self.shid=history.sid.intValue;
    self.timeInterval=[history.time timeIntervalSince1970]*1000;
    self.device=history.device;
    self.ip=history.ip;
    self.uid=history.user.sid.intValue;
    return self;
}

@end
