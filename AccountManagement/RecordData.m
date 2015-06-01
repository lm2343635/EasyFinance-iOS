//
//  RecordData.m
//  AccountManagement
//
//  Created by 李大爷 on 15/6/1.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "RecordData.h"

@implementation RecordData

@synthesize rid;
@synthesize money;
@synthesize remark;
@synthesize timeInterval;
@synthesize cid;
@synthesize aid;
@synthesize sid;
@synthesize pid;
@synthesize sync;

-(instancetype)initWithRecord:(Record *)record {
    self=[super init];
    self.rid=record.sid.intValue;
    self.money=record.money.doubleValue;
    self.remark=record.remark;
    //在Http传输中timeInterval以Java服务器中Date对象的interval为准
    //在Objective-C中的interval是Java中interval的千分之一，因此此处要乘1000还原为Java中的interval
    self.timeInterval=[record.time timeIntervalSince1970]*1000;
    self.cid=record.classification.sid.intValue;
    self.aid=record.account.sid.intValue;
    self.sid=record.shop.sid.intValue;
    self.pid=record.photo.sid.intValue;
    self.abid=record.accountBook.sid.intValue;
    self.sync=record.sync.intValue;
    return self;
}

@end
