//
//  ShopDao.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "ShopDao.h"

@implementation ShopDao

-(NSManagedObjectID *)saveWithSid:(NSNumber *)sid
                         andSname:(NSString *)sname
                         andSicon:(Icon *)sicon
                           andSin:(NSNumber *)sin
                          andSout:(NSNumber *)sout
                    inAccountBook:(AccountBook *)accountBook {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Shop *shop=[NSEntityDescription insertNewObjectForEntityForName:ShopEntityName
                                             inManagedObjectContext:self.cdh.context];
    shop.sid=sid;
    shop.sname=sname;
    shop.sicon=sicon;
    shop.sin=sin;
    shop.sout=sout;
    shop.accountBook=accountBook;
    //导入服务器数据时sync=1，默认认为它已同步
    shop.sync=[NSNumber numberWithInt:SYNCED];
    [self.cdh saveContext];
    return shop.objectID;
}

-(NSManagedObjectID *)saveWithAccountBook:(AccountBook *)accountBook
                                 andSname:(NSString *)sname
                                 andSicon:(Icon *)sicon {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    Shop *shop=[NSEntityDescription insertNewObjectForEntityForName:ShopEntityName
                                             inManagedObjectContext:self.cdh.context];
    shop.accountBook=accountBook;
    shop.sname=sname;
    shop.sicon=sicon;
    [self.cdh saveContext];
    return shop.objectID;
}

-(Shop *)getBySid:(NSNumber *)sid {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"sid=%@",sid];
    return (Shop *)[self getByPredicate:predicate withEntityName:ShopEntityName];
}

@end
