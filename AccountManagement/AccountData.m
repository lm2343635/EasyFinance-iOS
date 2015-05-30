//
//  AccountData.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/30.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AccountData.h"

@implementation AccountData

@synthesize aid;
@synthesize aname;
@synthesize ain;
@synthesize aout;
@synthesize iid;
@synthesize abid;
@synthesize sync;

-(instancetype)initWithAccount:(Account *)account {
    self=[super init];
    self.aid=account.sid.intValue;
    self.aname=account.aname;
    self.ain=account.ain.doubleValue;
    self.aout=account.aout.doubleValue;
    self.iid=account.aicon.sid.intValue;
    self.abid=account.accountBook.sid.intValue;
    self.sync=account.sync.intValue;
    return self;
}

@end
