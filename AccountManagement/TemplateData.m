//
//  TemplateData.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/30.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "TemplateData.h"

@implementation TemplateData

@synthesize tpid;
@synthesize tpname;
@synthesize cid;
@synthesize aid;
@synthesize sid;
@synthesize abid;
@synthesize sync;

-(instancetype)initWithTemplate:(Template *)template {
    self=[super init];
    self.tpid=template.sid.intValue;
    self.tpname=template.tpname;
    self.cid=template.classification.sid.intValue;
    self.aid=template.account.sid.intValue;
    self.sid=template.shop.sid.intValue;
    self.abid=template.accountBook.sid.intValue;
    return self;
}

@end
