//
//  TemplateData.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/30.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaoManager.h"

@interface TemplateData : NSObject

@property (nonatomic,retain) NSString *tpname;
@property (nonatomic) int tpid;
@property (nonatomic) int cid;
@property (nonatomic) int aid;
@property (nonatomic) int sid;
@property (nonatomic) int abid;
@property (nonatomic) int sync;

-(instancetype)initWithTemplate:(Template *)template;

@end
