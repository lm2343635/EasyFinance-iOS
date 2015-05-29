//
//  AccountBookData.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/29.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaoManager.h"

@interface AccountBookData : NSObject

@property (nonatomic, retain) NSString * abname;
@property (nonatomic) int abid;
@property (nonatomic) int iid;
@property (nonatomic) int uid;
@property (nonatomic) int sync;

-(instancetype)initWithAccountBook:(AccountBook *)accountBook;

@end
