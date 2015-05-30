//
//  AccountBookData.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/29.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AccountBookData.h"

@implementation AccountBookData

@synthesize abname;
@synthesize abid;
@synthesize iid;
@synthesize uid;
@synthesize sync;

-(instancetype)initWithAccountBook:(AccountBook *)accountBook {
    self=[super init];
    self.abname=accountBook.abname;
    self.abid=accountBook.sid.intValue;
    self.iid=accountBook.abicon.sid.intValue;
    self.uid=accountBook.user.sid.intValue;
    self.sync=accountBook.sync.intValue;
    return self;
}

@end
