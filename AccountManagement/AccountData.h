//
//  AccountData.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/30.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaoManager.h"

@interface AccountData : NSObject

@property (nonatomic) int aid;
@property (nonatomic, retain) NSString *aname;
@property (nonatomic) double ain;
@property (nonatomic) double aout;
@property (nonatomic) int iid;
@property (nonatomic) int abid;
@property (nonatomic) int sync;

-(instancetype)initWithAccount:(Account *)account;

@end
