//
//  PhotoData.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/30.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaoManager.h"

@interface PhotoData : NSObject

@property (nonatomic) int pid;
@property (nonatomic) long long timeInterval;
@property (nonatomic) int abid;
@property (nonatomic) int sync;

-(instancetype)initWithPhoto:(Photo *)photo;

@end
