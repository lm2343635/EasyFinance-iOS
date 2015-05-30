//
//  ClassificationData.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/30.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "ClassificationData.h"

@implementation ClassificationData

@synthesize cid;
@synthesize cname;
@synthesize cin;
@synthesize cout;
@synthesize iid;
@synthesize abid;
@synthesize sync;

-(instancetype)initWithClassification:(Classification *)classification {
    self=[super init];
    self.cid=classification.sid.intValue;
    self.cname=classification.cname;
    self.cin=classification.cin.doubleValue;
    self.cout=classification.cout.doubleValue;
    self.iid=classification.cicon.sid.intValue;
    self.abid=classification.accountBook.sid.intValue;
    self.sync=classification.sync.intValue;
    return self;
}

@end
