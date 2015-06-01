//
//  TransferData.m
//  AccountManagement
//
//  Created by 李大爷 on 15/6/1.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "TransferData.h"

@implementation TransferData

@synthesize tfid;
@synthesize tfoutid;
@synthesize tfinid;
@synthesize money;
@synthesize remark;
@synthesize timeInterval;
@synthesize sync;

-(instancetype)initWithTransfer:(Transfer *)transfer {
    self=[super init];
    self.tfid=transfer.sid.intValue;
    self.tfinid=transfer.tfin.sid.intValue;
    self.tfoutid=transfer.tfout.sid.intValue;
    self.money=transfer.money.doubleValue;
    self.remark=transfer.remark;
    self.timeInterval=[transfer.time timeIntervalSince1970]*1000;
    self.abid=transfer.accountBook.sid.intValue;
    self.sync=transfer.sync.intValue;
    return self;
}
@end
