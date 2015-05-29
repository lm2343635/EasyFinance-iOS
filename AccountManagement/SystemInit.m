//
//  SystemInit.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/2.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "SystemInit.h"

@implementation SystemInit {
    AFHTTPRequestOperationManager *manager;
    DaoManager *dao;
    NSNumber *importUserInfoUsid;
    User *importUser;
}

-(id)init {
    self=[super init];
    manager=[InternetHelper getRequestOperationManager];
    dao=[[DaoManager alloc] init];
    return self;
}

-(void)createSystemNullItems {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //新建系统空用户
    NSManagedObjectID *uid=[dao.userDao saveWithEmail:SYS_NULL_EMAIL
                                             andUname:SYS_NULL_USER
                                          andPassword:SYS_NULL_PASSWORD
                                               andSid:[NSNumber numberWithInt:SYS_NULL_ID]];
    if(DEBUG==1)
        NSLog(@"Create system null user(uid=%@)",uid);
    //新建系统空图标
    NSManagedObjectID *iid=[dao.iconDao saveWithSid:[NSNumber numberWithInt:SYS_NULL_ID]
                                            andType:[NSNumber numberWithInt:IconTypeSystemNull]
                                            andData:UIImagePNGRepresentation([UIImage imageNamed:SYS_NULL_ICON_PHOTO])];
    if(DEBUG==1)
        NSLog(@"Create system null icon(iid=%@)",iid);
    //设置系统空图标的用户为系统空用户
    Icon *icon=(Icon *)[dao getObjectById:iid];
    icon.sync=[NSNumber numberWithInt:SYNCED];
    User *user=(User *)[dao getObjectById:uid];
    icon.user=user;
    [dao.cdh saveContext];
    //新建系统空账本
    NSManagedObjectID *abid=[dao.accountBookDao saveWithSid:[NSNumber numberWithInt:SYS_NULL_ID]
                                                    andName:SYS_NULL_ACCOUNTBOOK
                                                    andIcon:icon
                                                    andUser:user];
    if(DEBUG==1)
        NSLog(@"Create system null account book (abid=%@)",abid);
    //设置系统空用户的账本为系统空账本
    AccountBook *accountBook=(AccountBook *)[dao getObjectById:abid];
    user.usingAccountBook=accountBook;
    [dao.cdh saveContext];
    //新建系统空照片
    PhotoDao *photoDao=[[PhotoDao alloc] init];
    NSManagedObjectID *upid=[photoDao saveWithSid:[NSNumber numberWithInt:SYS_NULL_ID]
                                         andData:UIImagePNGRepresentation([UIImage imageNamed:SYS_NULL_RECORD_PHOTO])];
    if(DEBUG==1)
        NSLog(@"Create system null photo for user (pid=%@)",upid);
    //设置系统空用户的照片为系统空照片
    Photo *userPhoto=(Photo *)[dao getObjectById:upid];
    user.photo=userPhoto;
    [dao.cdh saveContext];
    //新建系统空账本
    NSManagedObjectID *aid=[dao.accountDao saveWithSid:[NSNumber numberWithInt:SYS_NULL_ID]
                                              andAname:SYS_NULL_ACCOUNT
                                              andAicon:icon
                                                andAin:0
                                               andAout:0
                                         inAccountBook:accountBook];
    if(DEBUG==1)
        NSLog(@"Create system null account(aid=%@)",aid);
    //新建系统空类别
    NSManagedObjectID *cid=[dao.classificationDao saveWithSid:[NSNumber numberWithInt:SYS_NULL_ID]
                                                     andCname:SYS_NULL_CLASSIFICATION
                                                     andCicon:icon
                                                       andCin:0
                                                      andCout:0
                                                inAccountBook:accountBook];
    if(DEBUG==1)
        NSLog(@"Create system null classification(cid=%@)",cid);
    //新建系统空商家
    NSManagedObjectID *sid=[dao.shopDao saveWithSid:[NSNumber numberWithInt:SYS_NULL_ID]
                                           andSname:SYS_NULL_ACCOUNT
                                           andSicon:icon
                                             andSin:0
                                            andSout:0
                                      inAccountBook:accountBook];
    if(DEBUG==1)
        NSLog(@"Create system null shop(sid=%@)",sid);
    //收支记录空照片
    NSManagedObjectID *rpid=[photoDao saveWithSid:[NSNumber numberWithInt:SYS_RECORD_PHOTO_NULL]
                                          andData:UIImagePNGRepresentation([UIImage imageNamed:SYS_NULL_RECORD_PHOTO])];
    if(DEBUG==1)
        NSLog(@"Create system null photo for record (pid=%@)",rpid);
    
}

-(void)importDefaultDataFromServer {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    User *user=[dao.userDao getBySid:[NSNumber numberWithInt:SYS_NULL_ID]];
    [manager GET:[InternetHelper createUrl:@"iOSIconServlet?task=loadSystemIcons"]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if(DEBUG==1&&ShowServerMessage==1)
                 NSLog(@"Get message from server: %@",operation.responseString);
             NSArray *icons=[NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
             for(NSObject *object in icons) {
                 NSString *iname=[[object valueForKey:@"iname"] stringByDeletingPathExtension];
                 NSManagedObjectID *iid=[dao.iconDao saveWithSid:[object valueForKey:@"iid"]
                                                         andType:[NSNumber numberWithInt:[[object valueForKey:@"type"] intValue]]
                                                         andData:UIImagePNGRepresentation([UIImage imageNamed:iname])
                                                         andUser:user];
                 if(DEBUG==1)
                     NSLog(@"Create system icon with name='%@' and iid=%@",iname,iid);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Server Error: %@",error);
         }];
}

//-(User *)importUserInfoFromServer:(NSString *)email {
//    if(DEBUG==1)
//        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
//    //检查iOS客户端中是否存在该用户，如果该用户不为空，直接从iOS客户端中得到即可
//    importUser=[dao.userDao getByEmail:email];
//    //iOS客户端存在该用户直接返回用户即可
//    if(importUser!=nil)
//        return importUser;
////    
////    importUserInfoUsid=usid;
////    [self addObserver:self
////           forKeyPath:@"importUserInfoStatus"
////              options:NSKeyValueObservingOptionNew
////              context:nil];
////    //得到要导入的用户
////    importUser=[[DaoManager new].userDao getBySid:usid];
////    self.importUserInfoStatus=ImportUserInfoStatusStart;
//    return importUser;
//}
//
//

@end
