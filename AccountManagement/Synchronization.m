//
//  Synchronization.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/29.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "Synchronization.h"
#import "InternetHelper.h"
#import "NSObject+KJSerializer.h"
#import "AccountBookData.h"

@implementation Synchronization {
    AFHTTPRequestOperationManager *manager;
    DaoManager *dao;
    User *loginedUser;
}

-(instancetype)init {
    self=[super init];
    manager=[InternetHelper getRequestOperationManager];
    dao=[[DaoManager alloc] init];
    loginedUser=[dao.userDao getLoginedUser];
    return self;
}

-(void)registSyncKey {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //iOS设备信息
    NSString *iOSDeviceInfo=[NSString stringWithFormat:@"%@ iOS %@",
                             [[UIDevice currentDevice] name],
                             [[UIDevice currentDevice] systemVersion]];
    //注册同步密钥
    [manager POST:[InternetHelper createUrl:@"iOSSynchronizeServlet?task=resgistSyncKey"]
       parameters:@{
                    @"iOSDeviceInfo":iOSDeviceInfo,
                    @"uid":loginedUser.sid
                    }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(DEBUG==1)
                  NSLog(@"Get message from server: %@",operation.responseString);
              //在iOS客户端保存同步密钥
              loginedUser.syncKey=operation.responseString;
              [dao.cdh saveContext];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Server Error: %@",error);
          }];

}

-(void)synchronize {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@",self.class,NSStringFromSelector(_cmd));
    NSArray *accountBooks=[dao.accountBookDao findNotSyncByUser:loginedUser];
    //发送推送请求
    if(accountBooks.count>0) {
        NSMutableArray *accountBookDatas=[[NSMutableArray alloc] init];
        for(AccountBook *accountBook in accountBooks)
            [accountBookDatas addObject:[[AccountBookData alloc] initWithAccountBook:accountBook]];
        NSString *arrayString=[self createJSONArrayStringFromNSArray:accountBookDatas];
        [manager POST:[InternetHelper createUrl:@"iOSSynchronizeServlet?task=pushAccountBook"]
           parameters:@{@"array":arrayString}
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
                      if(DEBUG)
                          NSLog(@"Synchronized account book %@(sid=%d)",[object valueForKey:@"abname"],sabid);
                  }
                  //保存上下文
                  [dao.cdh saveContext];
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@",error);
              }];
    }
    //发送更新请求
    [manager POST:[InternetHelper createUrl:@"iOSSynchronizeServlet?task=updateAccountBook"]
       parameters:@{@"uid":loginedUser.sid}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(DEBUG==1)
                  NSLog(@"Get message from server: %@",operation.responseString);
              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
              for(NSObject *object in objects) {
                  int sabid=[[object valueForKey:@"abid"] intValue];
                  int iid=[[object valueForKey:@"iid"] intValue];
                  Icon *icon=[dao.iconDao getBySid:[NSNumber numberWithInt:iid]];
                  NSString *abname=[object valueForKey:@"abname"];
                  NSManagedObjectID *abid=[dao.accountBookDao saveWithSid:[NSNumber numberWithInt:sabid]
                                                                  andName:abname
                                                                  andIcon:icon
                                                                  andUser:loginedUser];
                  if(DEBUG==1)
                      NSLog(@"Sycnchronizd account book %@ from server with abid=%@",abname,abid);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@",error);
          }];
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
