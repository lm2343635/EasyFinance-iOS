//
//  PhotoDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/3.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "Photo.h"

#define PhotoEntityName @"Photo"

@interface PhotoDao : DaoTemplate

//导入默认空数据时使用
-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                          andData:(NSData *)pdata;

//新建照片使用
-(NSManagedObjectID *)saveWithData:(NSData *)pdata
                     inAccountBook:(AccountBook *)accountBook;

-(Photo *)getBySid:(NSNumber *)sid;
@end
