//
//  PhotoData.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/30.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "PhotoData.h"

@implementation PhotoData

@synthesize pid;
@synthesize timeInterval;
@synthesize sync;
@synthesize abid;

-(instancetype)initWithPhoto:(Photo *)photo {
    self=[super init];
    self.pid=photo.sid.intValue;
    self.timeInterval=[photo.upload timeIntervalSince1970]*1000;
    self.abid=photo.accountBook.sid.intValue;
    self.sync=photo.sync.intValue;
    return self;
}

@end
