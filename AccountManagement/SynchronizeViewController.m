//
//  SynchronizeViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/29.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "SynchronizeViewController.h"
#import "DaoManager.h"
#import "InternetHelper.h"
#import "NSObject+KJSerializer.h"
#import "AccountBookData.h"
#import "ClassificationData.h"
#import "AccountData.h"
#import "ShopData.h"

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

- (void)synchronize {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self addObserver:self
           forKeyPath:@"synchronizaStatus"
              options:NSKeyValueObservingOptionNew
              context:nil];
    //开始导入
    self.synchronizaStatus=SynchronizeStatusIcon;
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
                      NSLog(@"Synchronized account book %@(sid=%d)",[object valueForKey:@"abname"],sabid);
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
                      NSLog(@"Synchronized classification %@ (sid=%d)",[object valueForKey:@"cname"],scid);
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
                      NSLog(@"Synchronized account %@ (sid=%d)",[object valueForKey:@"aname"],said);
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
    self.synchronizaStatus++;
}

-(void)synchronizeTemplate {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self finishSynchronization];
}


-(void)finishSynchronization {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self removeObserver:self forKeyPath:@"synchronizaStatus"];
    //导入完成后退出导入界面，返回原来的界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
@end
