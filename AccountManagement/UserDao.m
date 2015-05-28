//
//  UserDao.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "UserDao.h"
#import "PhotoDao.h"
#import "SystemInit.h"

@implementation UserDao

-(NSManagedObjectID *)saveWithEmail:(NSString *)email
                           andUname:(NSString *)uname
                        andPassword:(NSString *)password
                             andSid:(NSNumber *)sid {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    User *user=[NSEntityDescription insertNewObjectForEntityForName:UserEntityName
                                             inManagedObjectContext:self.cdh.context];
    user.email=email;
    user.uname=uname;
    user.password=password;
    user.sid=sid;
    user.login=[NSNumber numberWithBool:NO];
    user.photo=[[[PhotoDao alloc] init] getBySid:[NSNumber numberWithInt:SYS_NULL_ID]];
    [self.cdh saveContext];
    return user.objectID;
}

-(User *)getBySid:(NSNumber *)sid {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return (User *)[self getByPredicate:[NSPredicate predicateWithFormat:@"sid=%@",sid]
                         withEntityName:UserEntityName];
}

-(User *)getByEmail:(NSString *)email {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return (User *)[self getByPredicate:[NSPredicate predicateWithFormat:@"email='%@'",email]
                         withEntityName:UserEntityName];

}

-(User *)getLoginedUser {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return (User *)[self getByPredicate:[NSPredicate predicateWithFormat:@"login=%@",[NSNumber numberWithBool:YES]]
                         withEntityName:UserEntityName];
}

-(void)setUserLogin:(BOOL)login withUid:(NSManagedObjectID *)uid {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    User *user=(User *)[self.cdh.context existingObjectWithID:uid error:nil];
    user.login=[NSNumber numberWithBool:YES];
    [self.cdh saveContext];
}


@end
