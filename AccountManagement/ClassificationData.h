//
//  ClassificationData.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/30.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaoManager.h"

@interface ClassificationData : NSObject

@property (nonatomic) int cid;
@property (nonatomic, retain) NSString *cname;
@property (nonatomic) double cin;
@property (nonatomic) double cout;
@property (nonatomic) int iid;
@property (nonatomic) int abid;
@property (nonatomic) int sync;

-(instancetype)initWithClassification:(Classification *)classification;
@end
