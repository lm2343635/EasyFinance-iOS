
//  SynchronizeViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/29.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "SynchronizeViewController.h"
#import "DaoManager.h"
#import "InternetHelper.h"
#import "DateTool.h"
#import "SystemInit.h"
#import "NSObject+KJSerializer.h"
#import "AccountBookData.h"
#import "ClassificationData.h"
#import "AccountData.h"
#import "ShopData.h"
#import "TemplateData.h"
#import "PhotoData.h"
#import "RecordData.h"
#import "TransferData.h"
#import "AccountHistoryData.h"
#import "SynchronizationHistoryData.h"

@interface SynchronizeViewController ()

@end

@implementation SynchronizeViewController {
    DaoManager *dao;
    AFHTTPRequestOperationManager *manager;
    User *loginedUser;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    manager=[InternetHelper getRequestOperationManager];
    loginedUser=[dao.userDao getLoginedUser];
    [self synchronize];
}

#pragma mark - UIAlertViewDelagate
-(void)alertViewCancel:(UIAlertView *)alertView {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    switch (buttonIndex) {
        case 0:
            loginedUser.login=[NSNumber numberWithBool:NO];
            [dao.cdh saveContext];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
}


#pragma mark - Service

- (void)synchronize {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //与服务器核对更新密钥，完成后重新生成更新密钥
    [manager POST:[InternetHelper createUrl:@"iOSSynchronizeServlet?task=checkSyncKey"]
       parameters:@{
                    @"uid":loginedUser.sid,
                    @"key":loginedUser.syncKey
                    }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(DEBUG==1)
                  NSLog(@"Get message from server: %@",operation.responseString);
              NSString *key=operation.responseString;
              //更新密钥非空说明客户端密钥与服务器匹配，否则不能完成更新
              if(![key isEqualToString:@""]) {
                  if(DEBUG==1)
                      NSLog(@"Update sync key %@ for user %@",key,loginedUser.uname);
                  //更新密钥
                  loginedUser.syncKey=key;
                  [dao.cdh saveContext];
                  //注册监听对象
                  [self addObserver:self
                         forKeyPath:@"synchronizaStatus"
                            options:NSKeyValueObservingOptionNew
                            context:nil];
                  //开始同步数据
                  self.synchronizaStatus=SynchronizeStatusIcon;
              }else{
                  UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                                message:@"Synchronization Key is illegal, this user may signed in other device, please sign out from this device and resign in."
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK",nil];
                  [alert show];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Server Error: %@",error);
          }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if([keyPath isEqualToString:@"synchronizaStatus"]) {
        switch (self.synchronizaStatus) {
            case SynchronizeStatusIcon:
                //现在还只有系统图标，跳过图标的导入
                self.synchronizaStatus++;
                break;
            case SynchronizeStatusAccountBook:
                [self synchronizeAccountBook];
                break;
            case SynchronizeStatusClassification:
                [self synchronizeClassification];
                break;
            case SynchronizeStatusAccount:
                [self synchronizeAccount];
                break;
            case SynchronizeStatusShop:
                [self synchronizeShop];
                break;
            case SynchronizeStatusTemplate:
                [self synchronizeTemplate];
                break;
            case SynchronizeStatusPhoto:
                [self synchronizePhoto];
                break;
            case SynchronizeStatusRecord:
                [self synchronizeRecord];
                break;
            case SynchronizeStatusTransfer:
                [self synchronizeTransfer];
                break;
            case SynchronizeStatusEnd:
                [self finishSynchronization];
                break;
            default:
                break;
        }
    }
}

-(void)synchronizeAccountBook {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //准备推送对象数组
    NSArray *accountBooks=[dao.accountBookDao findNotSyncByUser:loginedUser];
    NSMutableArray *accountBookDatas=[[NSMutableArray alloc] init];
    for(AccountBook *accountBook in accountBooks)
        [accountBookDatas addObject:[[AccountBookData alloc] initWithAccountBook:accountBook]];
    //发送推送请求
    [manager POST:[InternetHelper createUrl:@"iOSAccountBookServlet?task=push"]
       parameters:@{@"array":[self createJSONArrayStringFromNSArray:accountBookDatas]}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(DEBUG==1)
                  NSLog(@"Get message from server: %@",operation.responseString);
              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
              for(int i=0;i<accountBooks.count;i++) {
                  AccountBook *accountBook=[accountBooks objectAtIndex:i];
                  NSObject *object=[objects objectAtIndex:i];
                  int sabid=[[object valueForKey:@"abid"] intValue];
                  //服务器完成同步操作后设置客户端的同部属性为1
                  accountBook.sync=[NSNumber numberWithInt:SYNCED];
                  //设置服务器实体id
                  accountBook.sid=[NSNumber numberWithInt:sabid];
                  if(DEBUG==1)
                      NSLog(@"Synchronized account book %@ with server and update sid=%d",[object valueForKey:@"abname"],sabid);
              }
              //保存上下文
              [dao.cdh saveContext];
              //发送更新请求
              [manager POST:[InternetHelper createUrl:@"iOSAccountBookServlet?task=update"]
                 parameters:@{@"uid":loginedUser.sid}
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if(DEBUG==1)
                            NSLog(@"Get message from server: %@",operation.responseString);
                        NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
                        for(NSObject *object in objects) {
                            int sabid=[[object valueForKey:@"abid"] intValue];
                            int siid=[[object valueForKey:@"iid"] intValue];
                            Icon *icon=[dao.iconDao getBySid:[NSNumber numberWithInt:siid]];
                            NSString *abname=[object valueForKey:@"abname"];
                            NSManagedObjectID *abid=[dao.accountBookDao saveWithSid:[NSNumber numberWithInt:sabid]
                                                                            andName:abname
                                                                            andIcon:icon
                                                                            andUser:loginedUser];
                            if(DEBUG==1)
                                NSLog(@"Sycnchronizd account book %@ from server with abid=%@",abname,abid);
                        }
                        //推送请求和更新请求都执行完毕，跳转到下一个状态
                        self.synchronizaStatus++;
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Server Error: %@",error);
                    }];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Server Error: %@",error);
          }];
    
}

-(void)synchronizeClassification {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSArray *classifications=[dao.classificationDao findNotSyncByUser:loginedUser];
    NSMutableArray *classificationDatas=[[NSMutableArray alloc] init];
    for(Classification *classification in classifications)
        [classificationDatas addObject:[[ClassificationData alloc] initWithClassification:classification]];
    //发送推送请求
    [manager POST:[InternetHelper createUrl:@"iOSClassificationServlet?task=push"]
       parameters:@{@"array":[self createJSONArrayStringFromNSArray:classificationDatas]}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(DEBUG==1)
                  NSLog(@"Get message from server: %@",operation.responseString);
              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
              for(int i=0;i<classifications.count;i++) {
                  Classification *classification=[classifications objectAtIndex:i];
                  NSObject *object=[objects objectAtIndex:i];
                  int scid=[[object valueForKey:@"cid"] intValue];
                  classification.sid=[NSNumber numberWithInt:scid];
                  classification.sync=[NSNumber numberWithInt:SYNCED];
                  if(DEBUG==1)
                      NSLog(@"Synchronized classification %@ with server and update sid=%d",[object valueForKey:@"cname"],scid);
              }
              [dao.cdh saveContext];
              //发送更新请求
              [manager POST:[InternetHelper createUrl:@"iOSClassificationServlet?task=update"]
                 parameters:@{@"uid":loginedUser.sid}
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if(DEBUG==1)
                            NSLog(@"Get message from server: %@",operation.responseString);
                        NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
                        for(NSObject *object in objects) {
                            int scid=[[object valueForKey:@"cid"] intValue];
                            NSString *cname=[object valueForKey:@"cname"];
                            int siid=[[object valueForKey:@"iid"] intValue];
                            Icon *icon=[dao.iconDao getBySid:[NSNumber numberWithInt:siid]];
                            double cin=[[object valueForKey:@"cin"] doubleValue];
                            double cout=[[object valueForKey:@"cout"] doubleValue];
                            int sabid=[[object valueForKey:@"abid"] intValue];
                            AccountBook *accountBook=[dao.accountBookDao getBySid:[NSNumber numberWithInt:sabid]];
                            NSManagedObjectID *cid=[dao.classificationDao saveWithSid:[NSNumber numberWithInt:scid]
                                                                             andCname:cname
                                                                             andCicon:icon
                                                                               andCin:[NSNumber numberWithDouble:cin]
                                                                              andCout:[NSNumber numberWithDouble:cout]
                                                                        inAccountBook:accountBook];
                            if(DEBUG==1)
                                NSLog(@"Synchronized classification %@ from server with cid=%@",cname,cid);
                        }
                        self.synchronizaStatus++;
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Server Error: %@",error);
                    }];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Server Error: %@",error);
          }];
}

-(void)synchronizeAccount {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSArray *accounts=[dao.accountDao findNotSyncByUser:loginedUser];
    NSMutableArray *accountDatas=[[NSMutableArray alloc] init];
    for(Account *account in accounts)
        [accountDatas addObject:[[AccountData alloc] initWithAccount:account]];
    //发送推送请求
    [manager POST:[InternetHelper createUrl:@"iOSAccountServlet?task=push"]
       parameters:@{@"array":[self createJSONArrayStringFromNSArray:accountDatas]}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(DEBUG==1)
                  NSLog(@"Get message from server: %@",operation.responseString);
              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
              for(int i=0;i<accounts.count;i++) {
                  Account *account=[accounts objectAtIndex:i];
                  NSObject *object=[objects objectAtIndex:i];
                  int said=[[object valueForKey:@"aid"] intValue];
                  account.sid=[NSNumber numberWithInt:said];
                  account.sync=[NSNumber numberWithInt:SYNCED];
                  if(DEBUG==1)
                      NSLog(@"Synchronized account %@ with server and update sid=%d",[object valueForKey:@"aname"],said);
              }
              [dao.cdh saveContext];
              //发送更新请求
              [manager POST:[InternetHelper createUrl:@"iOSAccountServlet?task=update"]
                 parameters:@{@"uid":loginedUser.sid}
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if(DEBUG==1)
                            NSLog(@"Get message from server: %@",operation.responseString);
                        NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
                        for(NSObject *object in objects) {
                            int said=[[object valueForKey:@"aid"] intValue];
                            NSString *aname=[object valueForKey:@"aname"];
                            int siid=[[object valueForKey:@"iid"] intValue];
                            Icon *icon=[dao.iconDao getBySid:[NSNumber numberWithInt:siid]];
                            double ain=[[object valueForKey:@"ain"] doubleValue];
                            double aout=[[object valueForKey:@"aout"] doubleValue];
                            int sabid=[[object valueForKey:@"abid"] intValue];
                            AccountBook *accountBook=[dao.accountBookDao getBySid:[NSNumber numberWithInt:sabid]];
                            NSManagedObjectID *aid=[dao.accountDao saveWithSid:[NSNumber numberWithInt:said]
                                                                      andAname:aname
                                                                      andAicon:icon
                                                                        andAin:[NSNumber numberWithDouble:ain]
                                                                       andAout:[NSNumber numberWithDouble:aout]
                                                                 inAccountBook:accountBook];
                            if(DEBUG==1)
                                NSLog(@"Synchronized account %@ from server with aid=%@",aname,aid);
                        }
                        self.synchronizaStatus++;
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Server Error: %@",error);
                    }];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Server Error: %@",error);
          }];
}

-(void)synchronizeShop {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSArray *shops=[dao.shopDao findNotSyncByUser:loginedUser];
    NSMutableArray *shopDatas=[[NSMutableArray alloc] init];
    for(Shop *shop in shops)
        [shopDatas addObject:[[ShopData alloc] initWithShop:shop]];
    //发送推送请求
    [manager POST:[InternetHelper createUrl:@"iOSShopServlet?task=push"]
       parameters:@{@"array":[self createJSONArrayStringFromNSArray:shopDatas]}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(DEBUG==1)
                  NSLog(@"Get message from server: %@",operation.responseString);
              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
              for(int i=0;i<shops.count;i++) {
                  Shop *shop=[shops objectAtIndex:i];
                  NSObject *object=[objects objectAtIndex:i];
                  int ssid=[[object valueForKey:@"sid"] intValue];
                  shop.sid=[NSNumber numberWithInt:ssid];
                  shop.sync=[NSNumber numberWithInt:SYNCED];
                  if(DEBUG==1)
                      NSLog(@"Synchronized classification %@ with server and update sid=%d",[object valueForKey:@"sname"],ssid);
              }
              [dao.cdh saveContext];
              //发送更新请求
              [manager POST:[InternetHelper createUrl:@"iOSShopServlet?task=update"]
                 parameters:@{@"uid":loginedUser.sid}
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if(DEBUG==1)
                            NSLog(@"Get message from server: %@",operation.responseString);
                        NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
                        for(NSObject *object in objects) {
                            int ssid=[[object valueForKey:@"sid"] intValue];
                            NSString *sname=[object valueForKey:@"sname"];
                            int siid=[[object valueForKey:@"iid"] intValue];
                            Icon *icon=[dao.iconDao getBySid:[NSNumber numberWithInt:siid]];
                            double sin=[[object valueForKey:@"sin"] doubleValue];
                            double sout=[[object valueForKey:@"sout"] doubleValue];
                            int sabid=[[object valueForKey:@"abid"] intValue];
                            AccountBook *accountBook=[dao.accountBookDao getBySid:[NSNumber numberWithInt:sabid]];
                            NSManagedObjectID *sid=[dao.shopDao saveWithSid:[NSNumber numberWithInt:ssid]
                                                                   andSname:sname
                                                                   andSicon:icon
                                                                     andSin:[NSNumber numberWithDouble:sin]
                                                                    andSout:[NSNumber numberWithDouble:sout]
                                                              inAccountBook:accountBook];
                            if(DEBUG==1)
                                NSLog(@"Synchronized shop %@ from server with sid=%@",sname,sid);
                        }
                        self.synchronizaStatus++;
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Server Error: %@",error);
                    }];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Server Error: %@",error);
          }];
}

-(void)synchronizeTemplate {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSArray *templates=[dao.templateDao findNotSyncByUser:loginedUser];
    NSMutableArray *templateDatas=[[NSMutableArray alloc] init];
    for(Template *template in templates)
        [templateDatas addObject:[[TemplateData alloc] initWithTemplate:template]];
    //发送推送请求
    [manager POST:[InternetHelper createUrl:@"iOSTemplateServlet?task=push"]
       parameters:@{@"array":[self createJSONArrayStringFromNSArray:templateDatas]}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(DEBUG==1)
                  NSLog(@"Get message from server: %@",operation.responseString);
              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
              for (int i=0; i<templates.count; i++) {
                  Template *template=[templates objectAtIndex:i];
                  NSObject *object=[objects objectAtIndex:i];
                  int stpid=[[object valueForKey:@"tpid"] intValue];
                  template.sid=[NSNumber numberWithInt:stpid];
                  template.sync=[NSNumber numberWithInt:SYNCED];
                  if(DEBUG==1)
                      NSLog(@"Synchronized template %@ with server and update sid=%d",[object valueForKey:@"tpname"],stpid);
              }
              [dao.cdh saveContext];
              //发送更新请求
              [manager POST:[InternetHelper createUrl:@"iOSTemplateServlet?task=update"]
                 parameters:@{@"uid":loginedUser.sid}
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if(DEBUG==1)
                            NSLog(@"Get message from server: %@",operation.responseString);
                        NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
                        for(NSObject *object in objects) {
                            int stpid=[[object valueForKey:@"tpid"] intValue];
                            NSString *tpname=[object valueForKey:@"tpname"];
                            int scid=[[object valueForKey:@"cid"] intValue];
                            int said=[[object valueForKey:@"aid"] intValue];
                            int ssid=[[object valueForKey:@"sid"] intValue];
                            int sabid=[[object valueForKey:@"abid"] intValue];
                            Classification *classification=[dao.classificationDao getBySid:[NSNumber numberWithInt:scid]];
                            Account *account=[dao.accountDao getBySid:[NSNumber numberWithInt:said]];
                            Shop *shop=[dao.shopDao getBySid:[NSNumber numberWithInt:ssid]];
                            AccountBook *accountBook=[dao.accountBookDao getBySid:[NSNumber numberWithInt:sabid]];
                            NSManagedObjectID *tpid=[dao.templateDao saveWithSid:[NSNumber numberWithInt:stpid]
                                                                       andTpname:tpname
                                                               andClassification:classification
                                                                      andAccount:account
                                                                         andShop:shop
                                                                   inAccountBook:accountBook];
                            if(DEBUG==1)
                                NSLog(@"Synchronized template %@ from server with tpid=%@",tpname,tpid);
                        }
                        self.synchronizaStatus++;
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Server Error: %@",error);
                    }];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Server Error: %@",error);
          }];
}

-(void)synchronizePhoto {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSArray *photos=[dao.photoDao findNotSyncByUser:loginedUser];
    NSMutableArray *photoDatas=[[NSMutableArray alloc] init];
    for(Photo *photo in photos)
        [photoDatas addObject:[[PhotoData alloc] initWithPhoto:photo]];
    //发送推送请求
    [manager POST:[InternetHelper createUrl:@"iOSPhotoServlet?task=push"]
       parameters:@{@"array":[self createJSONArrayStringFromNSArray:photoDatas]}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(DEBUG==1)
                  NSLog(@"Get message from server: %@",operation.responseString);
              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
              for(int i=0;i<photos.count;i++) {
                  Photo *photo=[photos objectAtIndex:i];
                  NSObject *object=[objects objectAtIndex:i];
                  int spid=[[object valueForKey:@"pid"] intValue];
                  photo.sid=[NSNumber numberWithInt:spid];
                  photo.sync=[NSNumber numberWithInt:SYNCED];
                  if(DEBUG==1)
                      NSLog(@"Synchronized photo %@ with server and update sid=%d",[object valueForKey:@"timeInterval"],spid);
                  //上传图片
                  [manager POST:[InternetHelper createUrl:@"iOSPhotoUploadServlet"]
                     parameters:@{@"pid":[object valueForKey:@"pid"]}
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                            [formData appendPartWithFileData:photo.pdata
                                                        name:@"iOSClentUpload"
                                                    fileName:@"iOSClentUpload.jpg"
                                                    mimeType:@"image/jpeg"];
                        }
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if(DEBUG==1)
                                NSLog(@"Upload photo(spid=%d) to server successfully.",spid);
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"Server Error: %@",error);
                        }];
              }
              [dao.cdh saveContext];
              //发送更新请求
              [manager POST:[InternetHelper createUrl:@"iOSPhotoServlet?task=update"]
                 parameters:@{@"uid":loginedUser.sid}
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if(DEBUG==1)
                            NSLog(@"Get message from server: %@",operation.responseString);
                        NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
                        for(NSObject *object in objects) {
                            int spid=[[object valueForKey:@"pid"] intValue];
                            long long timeInterval=[[object valueForKey:@"timeInterval"] longLongValue];
                            NSDate *upload=[NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
                            int sabid=[[object valueForKey:@"abid"] intValue];
                            AccountBook *accountBook=[dao.accountBookDao getBySid:[NSNumber numberWithInt:sabid]];
                            NSManagedObjectID *pid=[dao.photoDao saveWithSid:[NSNumber numberWithInt:spid]
                                                                   andUpload:upload
                                                               inAccountBook:accountBook];
                            if(DEBUG==1)
                                NSLog(@"Synchronized photo %lld from server with sid=%@",timeInterval,pid);
                        }
                        self.synchronizaStatus++;
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Server Error: %@",error);
                    }];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Server Error: %@",error);
          }];
}

-(void)synchronizeRecord {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSArray *records=[dao.recordDao findNotSyncByUser:loginedUser];
    NSMutableArray *recordDatas=[[NSMutableArray alloc] init];
    for(Record *record in records)
        [recordDatas addObject:[[RecordData alloc] initWithRecord:record]];
    //发送推送请求
    [manager POST:[InternetHelper createUrl:@"iOSRecordServlet?task=push"]
       parameters:@{@"array":[self createJSONArrayStringFromNSArray:recordDatas]}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(DEBUG==1)
                  NSLog(@"Get message from server: %@",operation.responseString);
              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
              for (int i=0; i<records.count; i++) {
                  Record *record=[records objectAtIndex:i];
                  NSObject *object=[objects objectAtIndex:i];
                  int srid=[[object valueForKey:@"rid"] intValue];
                  record.sid=[NSNumber numberWithInt:srid];
                  record.sync=[NSNumber numberWithInt:SYNCED];
                  if(DEBUG==1)
                      NSLog(@"Synchronized record %@ with server and update sid=%d",[object valueForKey:@"timeInterval"],srid);
              }
              [dao.cdh saveContext];
              //发送更新请求
              [manager POST:[InternetHelper createUrl:@"iOSRecordServlet?task=update"]
                 parameters:@{@"uid":loginedUser.sid}
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if(DEBUG==1)
                            NSLog(@"Get message from server: %@",operation.responseString);
                        NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
                        for(NSObject *object in objects) {
                            int srid=[[object valueForKey:@"rid"] intValue];
                            double money=[[object valueForKey:@"money"] doubleValue];
                            NSString *remark=[object valueForKey:@"remark"];
                            long long timeInterval=[[object valueForKey:@"timeInterval"] longLongValue];
                            NSDate *time=[NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
                            int scid=[[object valueForKey:@"cid"] intValue];
                            int said=[[object valueForKey:@"aid"] intValue];
                            int ssid=[[object valueForKey:@"sid"] intValue];
                            int sabid=[[object valueForKey:@"abid"] intValue];
                            int spid=[[object valueForKey:@"pid"] intValue];
                            Classification *classification=[dao.classificationDao getBySid:[NSNumber numberWithInt:scid]];
                            Account *account=[dao.accountDao getBySid:[NSNumber numberWithInt:said]];
                            Shop *shop=[dao.shopDao getBySid:[NSNumber numberWithInt:ssid]];
                            AccountBook *accountBook=[dao.accountBookDao getBySid:[NSNumber numberWithInt:sabid]];
                            Photo *photo=nil;
                            //iOS客户端空照片就设为null，只有当照片不为系统空收支记录照片时才设置photo
                            if(spid!=SYS_RECORD_PHOTO_NULL)
                                photo=[dao.photoDao getBySid:[NSNumber numberWithInt:spid]];
                            NSManagedObjectID *rid=[dao.recordDao synchronizeWithSid:[NSNumber numberWithInt:srid]
                                                                            andMoney:[NSNumber numberWithDouble:money]
                                                                           andRemark:remark
                                                                             andTime:time
                                                                   andClassification:classification
                                                                          andAccount:account
                                                                             andShop:shop
                                                                            andPhoto:photo
                                                                       inAccountBook:accountBook];
                            if(DEBUG==1)
                                NSLog(@"Synchronized record %lld from server with rid=%@",timeInterval,rid);
                        }
                        self.synchronizaStatus++;
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Server Error: %@",error);
                    }];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Server Error: %@",error);
          }];
}

-(void)synchronizeTransfer {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSArray *transfers=[dao.transferDao findNotSyncByUser:loginedUser];
    NSMutableArray *transferDatas=[[NSMutableArray alloc] init];
    for(Transfer *transfer in transfers)
        [transferDatas addObject:[[TransferData alloc] initWithTransfer:transfer]];
    //发送推送请求
    [manager POST:[InternetHelper createUrl:@"iOSTransferServlet?task=push"]
       parameters:@{@"array":[self createJSONArrayStringFromNSArray:transferDatas]}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(DEBUG==1)
                  NSLog(@"Get message from server: %@",operation.responseString);
              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
              for (int i=0; i<transfers.count; i++) {
                  Transfer *transfer=[transfers objectAtIndex:i];
                  NSObject *object=[objects objectAtIndex:i];
                  int stfid=[[object valueForKey:@"tfid"] intValue];
                  transfer.sid=[NSNumber numberWithInt:stfid];
                  transfer.sync=[NSNumber numberWithInt:SYNCED];
                  if(DEBUG==1)
                      NSLog(@"Synchronized transfer %@ with server and update sid=%d",[object valueForKey:@"timeInterval"],stfid);
              }
              [dao.cdh saveContext];
              //发送更新请求
              [manager POST:[InternetHelper createUrl:@"iOSTransferServlet?task=update"]
                 parameters:@{@"uid":loginedUser.sid}
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if(DEBUG==1)
                            NSLog(@"Get message from server: %@",operation.responseString);
                        NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
                        for(NSObject *object in objects) {
                            int stfid=[[object valueForKey:@"tfid"] intValue];
                            double money=[[object valueForKey:@"money"] doubleValue];
                            NSString *remark=[object valueForKey:@"remark"];
                            long long timeInterval=[[object valueForKey:@"timeInterval"] longLongValue];
                            NSDate *time=[NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
                            int tfinid=[[object valueForKey:@"tfinid"] intValue];
                            int tfoutid=[[object valueForKey:@"tfoutid"] intValue];
                            int sabid=[[object valueForKey:@"abid"] intValue];
                            Account *tfin=[dao.accountDao getBySid:[NSNumber numberWithInt:tfinid]];
                            Account *tfout=[dao.accountDao getBySid:[NSNumber numberWithInt:tfoutid]];
                            AccountBook *accountBook=[dao.accountBookDao getBySid:[NSNumber numberWithInt:sabid]];
                            NSManagedObjectID *tfid=[dao.transferDao synchronizeWithSid:[NSNumber numberWithInt:stfid]
                                                                               andMoney:[NSNumber numberWithDouble:money]
                                                                              andRemark:remark
                                                                                andTime:time
                                                                          andOutAccount:tfout
                                                                           andInAccount:tfin
                                                                          inAccountBook:accountBook];
                            if(DEBUG==1)
                                NSLog(@"Synchronized transfer %lld from server with tfid=%@",timeInterval,tfid);
                        }
                        self.synchronizaStatus++;
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Server Error: %@",error);
                    }];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Server Error: %@",error);
          }];
}

//暂时作废的方法
-(void)synchronizeAccountHistory {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSArray *accountHistories=[dao.accountHistoryDao findNotSyncByUser:loginedUser];
    NSMutableArray *accountHistoryDatas=[[NSMutableArray alloc] init];
    for(AccountHistory *accountHistory in accountHistories)
        [accountHistoryDatas addObject:[[AccountHistoryData alloc] initWithAccountHistory:accountHistory]];
    //发送推送请求
    [manager POST:[InternetHelper createUrl:@"iOSAccountHistoryServlet?task=push"]
       parameters:@{@"array":[self createJSONArrayStringFromNSArray:accountHistoryDatas]}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(DEBUG==1)
                  NSLog(@"Get message from server: %@",operation.responseString);
              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
              for (int i=0; i<accountHistories.count; i++) {
                  AccountHistory *accountHistory=[accountHistories objectAtIndex:i];
                  NSObject *object=[objects objectAtIndex:i];
                  int sahid=[[object valueForKey:@"ahid"] intValue];
                  accountHistory.sid=[NSNumber numberWithInt:sahid];
                  accountHistory.sync=[NSNumber numberWithInt:SYNCED];
                  if(DEBUG==1)
                      NSLog(@"Synchronized account history %@ with server and update sid=%d",[object valueForKey:@"timeInterval"],sahid);
              }
              [dao.cdh saveContext];
              //发送更新请求
              [manager POST:[InternetHelper createUrl:@"iOSAccountHistoryServlet?task=update"]
                 parameters:@{@"uid":loginedUser.sid}
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if(DEBUG==1)
                            NSLog(@"Get message from server: %@",operation.responseString);
                        NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
                        for(NSObject *object in objects) {
                            int sahid=[[object valueForKey:@"ahid"] intValue];
                            double ain=[[object valueForKey:@"ain"] doubleValue];
                            double aout=[[object valueForKey:@"aout"] doubleValue];
                            long long timeInterval=[[object valueForKey:@"timeInterval"] longLongValue];
                            NSDate *date=[NSDate dateWithTimeIntervalSince1970:timeInterval];
                            int said=[[object valueForKey:@"aid"] intValue];
                            Account *account=[dao.accountDao getBySid:[NSNumber numberWithInt:said]];
                            NSManagedObjectID *ahid=[dao.accountHistoryDao saveBySid:[NSNumber numberWithInt:sahid]
                                                                              andAin:[NSNumber numberWithDouble:ain]
                                                                             andAout:[NSNumber numberWithDouble:aout]
                                                                              onDate:date
                                                                           inAccount:account];
                            if(DEBUG==1)
                                NSLog(@"Synchronized account history %lld from server with ahid=%@",timeInterval,ahid);
                        }
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Server Error: %@",error);
                    }];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Server Error: %@",error);
          }];
    self.synchronizaStatus++;
}

-(void)finishSynchronization {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self removeObserver:self forKeyPath:@"synchronizaStatus"];
    //在iOS客户端创建同步历史记录
    NSManagedObjectID *shid=[dao.synchronizationHistoryDao saveWithTime:[NSDate date]
                                                              andDevice:[InternetHelper getDeviceInfo]
                                                                 inUser:loginedUser];
    if(DEBUG==1)
        NSLog(@"Create accountHistory(ahid=%@) for user %@",shid,loginedUser.uname);
    SynchronizationHistory *history=(SynchronizationHistory *)[dao getObjectById:shid];
    SynchronizationHistoryData *data=[[SynchronizationHistoryData alloc] initWithSynchronizationHistory:history];
    //把同步记录发送给服务器
    [manager POST:[InternetHelper createUrl:@"iOSSynchronizeServlet?task=receiveSynchronizationHistory"]
       parameters:@{@"object":[self createJSONObjectFromNSObject:data]}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(DEBUG==1)
                  NSLog(@"Get message from server: %@",operation.responseString);
              NSObject *object=[NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
              int sshid=[[object valueForKey:@"shid"] intValue];
              history.sid=[NSNumber numberWithInt:sshid];
              history.ip=[object valueForKey:@"ip"];
              [dao.cdh saveContext];
              if(DEBUG==1)
                  NSLog(@"Update synchronization history %@ set shid=%d",[object valueForKey:@"timeInterval"],sshid);
              //导入完成后退出导入界面，返回原来的界面
              [self dismissViewControllerAnimated:YES completion:nil];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Server Error: %@",error);
          }];
}

//根据数组得到json字符串
-(NSString *)createJSONArrayStringFromNSArray:(NSArray *)array {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@",self.class,NSStringFromSelector(_cmd));
    NSData *data=nil;
    NSError *error=nil;
    if(array.count==0)
        return @"[]";
    NSMutableString *jsonArrayString=[NSMutableString stringWithFormat:@"["];
    int count=0;
    for(NSObject *object in array) {
        //首先把对象转化成字典，这里的对象中只能包含基本数据
        //然后吧字典转换成数据
        data=[NSJSONSerialization dataWithJSONObject:[object getDictionary]
                                             options:NSJSONWritingPrettyPrinted
                                               error:&error];
        if(error)
            NSLog(@"Error: %@",error);
        //根据数据得到JSON字符串
        [jsonArrayString appendFormat:@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        if(count<array.count-1)
            [jsonArrayString appendString:@","];
        else
            [jsonArrayString appendString:@"]"];
        count++;
    }
    return jsonArrayString;
}

//根据对象得到json字符串
-(NSString *)createJSONObjectFromNSObject:(NSObject *)object {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@",self.class,NSStringFromSelector(_cmd));
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:[object getDictionary]
                                                 options:NSJSONWritingPrettyPrinted
                                                   error:&error];
    if(error)
        NSLog(@"Error: %@",error);
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end
