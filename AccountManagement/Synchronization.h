//
//  Synchronization.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/29.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InternetHelper.h"

@interface Synchronization : NSObject

-(instancetype)init;
-(void)registSyncKey;
-(void)synchronize;

@end
