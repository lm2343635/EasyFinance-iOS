//
//  TransferData.h
//  AccountManagement
//
//  Created by 李大爷 on 15/6/1.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaoManager.h"

@interface TransferData : NSObject

@property (nonatomic) int tfid;
@property (nonatomic) int tfoutid;
@property (nonatomic) int tfinid;
@property (nonatomic) double money;
@property (nonatomic) NSString *remark;
@property (nonatomic) long timeInterval;
@property (nonatomic) int abid;
@property (nonatomic) int sync;

-(instancetype)initWithTransfer:(Transfer *)transfer;
@end
