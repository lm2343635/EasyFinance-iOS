//
//  PhotoDao.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/3.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"
#import "Photo.h"
#import "User.h"

#define PhotoEntityName @"Photo"

@interface PhotoDao : DaoTemplate

//导入默认空数据时使用
-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                          andData:(NSData *)pdata;

//新建照片使用
-(NSManagedObjectID *)saveWithData:(NSData *)pdata
                     inAccountBook:(AccountBook *)accountBook;

//导入服务器照片使用
-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                        andUpload:(NSDate *)upload
                    inAccountBook:(AccountBook *)accountBook;

-(Photo *)getBySid:(NSNumber *)sid;

//得到指定用户未同步的照片
-(NSArray *)findNotSyncByUser:(User *)user;
@end
