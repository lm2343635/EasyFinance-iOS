//
//  RecordData.h
//  AccountManagement
//
//  Created by 李大爷 on 15/6/1.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaoManager.h"

@interface RecordData : NSObject

@property (nonatomic) int rid;
@property (nonatomic) double money;
@property (nonatomic, retain) NSString *remark;
@property (nonatomic) long timeInterval;
@property (nonatomic) int cid;
@property (nonatomic) int aid;
@property (nonatomic) int sid;
@property (nonatomic) int pid;
@property (nonatomic) int abid;
@property (nonatomic) int sync;

-(instancetype)initWithRecord:(Record *)record;

@end
