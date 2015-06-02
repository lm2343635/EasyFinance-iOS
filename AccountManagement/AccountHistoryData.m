//
//  AccountHistoryData.m
//  AccountManagement
//
//  Created by 李大爷 on 15/6/1.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AccountHistoryData.h"

@implementation AccountHistoryData

@synthesize ahid;
@synthesize timeInterval;
@synthesize aout;
@synthesize ain;
@synthesize aid;
@synthesize sync;

-(instancetype)initWithAccountHistory:(AccountHistory *)accountHistory {
    self=[super init];
    self.ahid=accountHistory.sid.intValue;
    self.timeInterval=[accountHistory.date timeIntervalSince1970];
    self.aout=accountHistory.aout.doubleValue;
    self.ain=accountHistory.ain.doubleValue;
    self.aid=accountHistory.account.sid.intValue;
    self.sync=accountHistory.sync.intValue;
    return self;
}
@end
