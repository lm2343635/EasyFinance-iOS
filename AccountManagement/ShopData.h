//
//  ShopData.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/30.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaoManager.h"

@interface ShopData : NSObject

@property (nonatomic) int sid;
@property (nonatomic, retain) NSString *sname;
@property (nonatomic) double sin;
@property (nonatomic) double sout;
@property (nonatomic) int iid;
@property (nonatomic) int abid;
@property (nonatomic) int sync;

-(instancetype)initWithShop:(Shop *)shop;

@end
