//
//  ShopData.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/30.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "ShopData.h"

@implementation ShopData

@synthesize sid;
@synthesize sname;
@synthesize sin;
@synthesize sout;
@synthesize iid;
@synthesize abid;
@synthesize sync;

-(instancetype)initWithShop:(Shop *)shop {
    self=[super init];
    self.sid=shop.sid.intValue;
    self.sname=shop.sname;
    self.sin=shop.sin.doubleValue;
    self.sout=shop.sout.doubleValue;
    self.iid=shop.sicon.sid.intValue;
    self.abid=shop.accountBook.sid.intValue;
    self.sync=shop.sync.intValue;
    return self;
}

@end
