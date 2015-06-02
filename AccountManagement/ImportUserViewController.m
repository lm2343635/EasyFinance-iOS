//
//  ImportUserViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/7.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "ImportUserViewController.h"
#import "InternetHelper.h"
#import "DaoManager.h"
#import "SystemInit.h"
#import "Synchronization.h"

@interface ImportUserViewController ()

@end

@implementation ImportUserViewController {
    DaoManager *dao;
    AFHTTPRequestOperationManager *manager;
    NSNumber *importUserUsid;
    User *importUser;
    int count;
    NSDateFormatter *dateFormatter;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    manager=[InternetHelper getRequestOperationManager];
    dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //清空导入控制台
    self.consoleTextView.text=@"";
    //开始导入数据
    [self importUserInfoFromServer];
}

#pragma mark - Service
-(void)importUserInfoFromServer{
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //能跳入该界面，说明用户没有被导入iOS客户端数据库，所以在此不用判断用户导入情况，直接从服务器导入即可
    //开始监听导入状态
    [self addObserver:self
           forKeyPath:@"importUserInfoStatus"
              options:NSKeyValueObservingOptionNew
              context:nil];
    //导入控制台显示开始导入
    [self refreshConsole:@"Start importing from server..."];
    //设置导入状态为起始状态，开始导入数据
    self.importUserInfoStatus=ImportUserInfoStatusStart;
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //使用KVO键值监听来监听导入用户信息状态标志位importUserInfoStatus的变化，控制导入流程的顺序进行
    if([keyPath isEqualToString:@"importUserInfoStatus"]) {
        switch (self.importUserInfoStatus) {
            //起始状态，导入用户，设置全局变量服务器用户id（usid）
            case ImportUserInfoStatusStart: {
                if(DEBUG==1)
                    NSLog(@"Importing user... ImportUserInfoStatus=%ld",self.importUserInfoStatus);
                [manager POST:[InternetHelper createUrl:@"iOSUserServlet?task=getUser"]
                   parameters:@{@"email":self.email}
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          if(DEBUG==1)
                              NSLog(@"Get message from server: %@",operation.responseString);
                          NSObject *object=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:nil];
                          //设置全局变量服务器用户id（usid）
                          importUserUsid=[NSNumber numberWithInt:[[object valueForKey:@"uid"] intValue]];
                          //存储用户对象到iOS客户端数据库
                          NSManagedObjectID *uid=[dao.userDao saveWithEmail:[object valueForKey:@"email"]
                                                                   andUname:[object valueForKey:@"uname"]
                                                                andPassword:[object valueForKey:@"password"]
                                                                     andSid:importUserUsid];
                          if(DEBUG==1)
                              NSLog(@"Create user(uid=%@)",uid);
                          //设置全局变量用户对象importUser
                          importUser=(User *)[dao getObjectById:uid];
                          //在consoleTextView中显示导入状态
                          [self refreshConsole:[NSString stringWithFormat:@"Importing user: %@...",importUser.uname]];
                          //监听状态加1
                          self.importUserInfoStatus++;
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"Server Error: %@",error);
                      }];
                break;
            }
            case ImportUserInfoStatusAccountBooks: {
                if(DEBUG==1)
                    NSLog(@"Importing user account books...ImportUserInfoStatus=%ld",self.importUserInfoStatus);
                //从服务器导入账本
                [manager POST:[InternetHelper createUrl:@"iOSAccountBookServlet?task=getUserAccountBooks"]
                   parameters:@{@"uid":importUserUsid}
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          if(DEBUG==1)
                              NSLog(@"Get message from server: %@",operation.responseString);
                          NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:nil];
                          for(NSObject *object in objects) {
                              int siid=[[[object valueForKey:@"abicon"] valueForKey:@"iid"] intValue];
                              Icon *icon=[dao.iconDao getBySid:[NSNumber numberWithInt:siid]];
                              int sabid=[[object valueForKey:@"abid"] intValue];
                              NSManagedObjectID *abid=[dao.accountBookDao saveWithSid:[NSNumber numberWithInt:sabid]
                                                                              andName:[object valueForKey:@"abname"]
                                                                              andIcon:icon
                                                                              andUser:importUser];
                              if(DEBUG==1)
                                  NSLog(@"Create account book (abid=%@) for %@",abid,importUser.uname);
                              //在consoleTextView中显示导入状态
                              [self refreshConsole:[NSString stringWithFormat:@"Importing account book: %@",[object valueForKey:@"abname"]]];
                          }
                          //监听状态加1
                          self.importUserInfoStatus++;
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"Import account books failed. Server Error: %@",error);
                      }];
                break;
            }
            case ImportUserInfoStatudUsingAccountBook: {
                if(DEBUG==1)
                    NSLog(@"Importing using account book...ImportUserInfoStatus=%ld",self.importUserInfoStatus);
                //导入用户默认账本
                [manager POST:[InternetHelper createUrl:@"iOSAccountBookServlet?task=getUsingAccountBook"]
                   parameters:@{@"uid":importUserUsid}
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          if(DEBUG==1)
                              NSLog(@"Get message from server: %@",operation.responseString);
                          NSObject *object=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:nil];
                          int sabid=[[object valueForKey:@"abid"] intValue];
                          AccountBook *accountBook=[dao.accountBookDao getBySid:[NSNumber numberWithInt:sabid]];
                          importUser.usingAccountBook=accountBook;
                          [dao.cdh saveContext];
                          //监听状态加1
                          self.importUserInfoStatus++;
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"Import using account book failed. Server Error:%@",error);
                      }];
                break;
            }
            case ImportUserInfoStatusClassification: {
                if(DEBUG==1)
                    NSLog(@"Importing classifications...");
                //导入各个账本下的分类
                count=0;
                NSSet *accountBooks=importUser.accountBooks;
                for(AccountBook *accountBook in accountBooks) {
                    [manager POST:[InternetHelper createUrl:@"iOSClassificationServlet?task=getClassifications"]
                       parameters:@{@"abid":accountBook.sid}
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              if(DEBUG==1)
                                  NSLog(@"Get message from server: %@",operation.responseString);
                              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                              for(NSObject *object in objects) {
                                  int siid=[[[object valueForKey:@"cicon"] valueForKey:@"iid"] intValue];
                                  Icon *icon=[dao.iconDao getBySid:[NSNumber numberWithInt:siid]];
                                  int scid=[[object valueForKey:@"cid"] intValue];
                                  double cin=[[object valueForKey:@"cin"] doubleValue];
                                  double cout=[[object valueForKey:@"cout"] doubleValue];
                                  NSManagedObjectID *cid=[dao.classificationDao saveWithSid:[NSNumber numberWithInt:scid]
                                                                                   andCname:[object valueForKey:@"cname"]
                                                                                   andCicon:icon
                                                                                     andCin:[NSNumber numberWithDouble:cin]
                                                                                    andCout:[NSNumber numberWithDouble:cout]
                                                                              inAccountBook:accountBook];
                                  if(DEBUG==1)
                                      NSLog(@"Create classification(cid=%@) in accountBook %@",cid,accountBook.abname);
                                  [self refreshConsole:[NSString stringWithFormat:@"Importing classification: %@ in accoout book: %@",[object valueForKey:@"cname"],accountBook.abname]];
                              }
                              count++;
                              if(count==accountBooks.count)
                                  self.importUserInfoStatus++;
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Import classification failed. Server Error: %@",error);
                          }];
                }
                
                break;
            }
            case ImportUserInfoStatusAccount: {
                if(DEBUG==1)
                    NSLog(@"Importing accounts...");
                //导入各个账本下的账户
                count=0;
                NSSet *accountBooks=importUser.accountBooks;
                for(AccountBook *accountBook in accountBooks) {
                    [manager POST:[InternetHelper createUrl:@"iOSAccountServlet?task=getAccounts"]
                       parameters:@{@"abid":accountBook.sid}
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              if(DEBUG==1)
                                  NSLog(@"Get message from server: %@",operation.responseString);
                              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                              for(NSObject *object in objects) {
                                  int aiid=[[[object valueForKey:@"aicon"] valueForKey:@"iid"] intValue];
                                  Icon *icon=[dao.iconDao getBySid:[NSNumber numberWithInt:aiid]];
                                  int said=[[object valueForKey:@"aid"] intValue];
                                  double ain=[[object valueForKey:@"ain"] doubleValue];
                                  double aout=[[object valueForKey:@"aout"] doubleValue];
                                  NSManagedObjectID *aid=[dao.accountDao saveWithSid:[NSNumber numberWithInt:said]
                                                                            andAname:[object valueForKey:@"aname"]
                                                                            andAicon:icon
                                                                              andAin:[NSNumber numberWithDouble:ain]
                                                                             andAout:[NSNumber numberWithDouble:aout]
                                                                       inAccountBook:accountBook];
                                  if(DEBUG==1)
                                      NSLog(@"Create account(aid=%@) in accountBook %@",aid,accountBook.abname);
                                  [self refreshConsole:[NSString stringWithFormat:@"Importing account: %@ in account book: %@",[object valueForKey:@"aname"],accountBook.abname]];
                              }
                              count++;
                              if(count==accountBooks.count)
                                  self.importUserInfoStatus++;
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Import account failed. Server Error: %@",error);
                          }];
                }
                break;
            }
            case ImportUserInfoStatusShop: {
                if(DEBUG==1)
                    NSLog(@"Importing accounts...");
                //导入各个账本下的账户
                count=0;
                NSSet *accountBooks=importUser.accountBooks;
                for(AccountBook *accountBook in accountBooks) {
                    [manager POST:[InternetHelper createUrl:@"iOSShopServlet?task=getShops"]
                       parameters:@{@"abid":accountBook.sid}
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              if(DEBUG==1)
                                  NSLog(@"Get message from server: %@",operation.responseString);
                              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                              for(NSObject *object in objects) {
                                  int siid=[[[object valueForKey:@"sicon"] valueForKey:@"iid"] intValue];
                                  Icon *icon=[dao.iconDao getBySid:[NSNumber numberWithInt:siid]];
                                  int ssid=[[object valueForKey:@"sid"] intValue];
                                  double sin=[[object valueForKey:@"sin"] doubleValue];
                                  double sout=[[object valueForKey:@"sout"] doubleValue];
                                  NSManagedObjectID *sid=[dao.shopDao saveWithSid:[NSNumber numberWithInt:ssid]
                                                                         andSname:[object valueForKey:@"sname"]
                                                                         andSicon:icon
                                                                           andSin:[NSNumber numberWithDouble:sin]
                                                                          andSout:[NSNumber numberWithDouble:sout]
                                                                    inAccountBook:accountBook];
                                  if(DEBUG==1)
                                      NSLog(@"Create shop(sid=%@) in accountBook %@",sid,accountBook.abname);
                                  [self refreshConsole:[NSString stringWithFormat:@"Importing shop: %@ in account book: %@",[object valueForKey:@"sname"],accountBook.abname]];
                              }
                              count++;
                              if(count==accountBooks.count)
                                  self.importUserInfoStatus++;
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Import account failed. Server Error: %@",error);
                          }];
                }
                break;
            }
            case ImportUserInfoStatusTemplate: {
                if(DEBUG==1)
                    NSLog(@"Importing templates...");
                //导入各个账本下的账户
                count=0;
                NSSet *accountBooks=importUser.accountBooks;
                for(AccountBook *accountBook in accountBooks) {
                    [manager POST:[InternetHelper createUrl:@"iOSTemplateServlet?task=getTemplates"]
                       parameters:@{@"abid":accountBook.sid}
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              if(DEBUG==1)
                                  NSLog(@"Get message from server: %@",operation.responseString);
                              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                              for(NSObject *object in objects) {
                                  int stpid=[[object valueForKey:@"tpid"] intValue];
                                  int scid=[[[object valueForKey:@"classification"] valueForKey:@"cid"] intValue];
                                  int said=[[[object valueForKey:@"account"] valueForKey:@"aid"] intValue];
                                  int ssid=[[[object valueForKey:@"shop"] valueForKey:@"sid"] intValue];
                                  Classification *classification=[dao.classificationDao getBySid:[NSNumber numberWithInt:scid]];
                                  Account *account=[dao.accountDao getBySid:[NSNumber numberWithInt:said]];
                                  Shop *shop=[dao.shopDao getBySid:[NSNumber numberWithInt:ssid]];
                                  NSManagedObjectID *tpid=[dao.templateDao saveWithSid:[NSNumber numberWithInt:stpid]
                                                                             andTpname:[object valueForKey:@"tpname"]
                                                                     andClassification:classification
                                                                            andAccount:account
                                                                               andShop:shop
                                                                         inAccountBook:accountBook];
                                  if(DEBUG==1)
                                      NSLog(@"Create template(tpid=%@) in accountBook %@",tpid,accountBook.abname);
                                  [self refreshConsole:[NSString stringWithFormat:@"Importing template: %@ in account book: %@",[object valueForKey:@"tpname"],accountBook.abname]];
                              }
                              count++;
                              if(count==accountBooks.count)
                                  self.importUserInfoStatus++;
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Importing templates failed. Server Error: %@",error);
                          }];
                }
                break;
            }
            case ImportUserInfoStatusPhoto: {
                if(DEBUG==1)
                    NSLog(@"Importing Photos...");
                //导入各个账本下的照片
                count=0;
                NSSet *accountBooks=importUser.accountBooks;
                for(AccountBook *accountBook in accountBooks) {
                    [manager POST:[InternetHelper createUrl:@"iOSPhotoServlet?task=getPhotos"]
                       parameters:@{@"abid":accountBook.sid}
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
                                  NSManagedObjectID *pid=[dao.photoDao saveWithSid:[NSNumber numberWithInt:spid]
                                                                         andUpload:upload
                                                                     inAccountBook:accountBook];
                                  if(DEBUG==1)
                                      NSLog(@"Create Photo(pid=%@) in accountBook %@",pid,accountBook.abname);
                                  [self refreshConsole:[NSString stringWithFormat:@"Importing photo uploaded in %@ in account book: %@",[dateFormatter stringFromDate:upload],accountBook.abname]];
                              }
                              count++;
                              if(count==accountBooks.count)
                                  self.importUserInfoStatus++;
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Importing photos failed. Server Error: %@",error);
                          }];
                }
                break;
            }
            case ImportUserInfoStatusIcon: {
                //暂无用户自定义图标,跳过
                self.importUserInfoStatus++;
                break;
            }
            case ImportUserInfoStatusRecord: {
                if(DEBUG==1)
                    NSLog(@"Importing Records...");
                count=0;
                NSSet *accountBooks=importUser.accountBooks;
                for(AccountBook *accountBook in accountBooks) {
                    [manager POST:[InternetHelper createUrl:@"iOSRecordServlet?task=getRecords"]
                       parameters:@{@"abid":accountBook.sid}
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              if(DEBUG==1)
                                  NSLog(@"Get message from server: %@",operation.responseString);
                              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                              for(NSObject *object in objects) {
                                  long long timeInterval=[[object valueForKey:@"timeInterval"] longLongValue];
                                  NSDate *time=[NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
                                  int srid=[[object valueForKey:@"rid"] intValue];
                                  int scid=[[object valueForKey:@"cid"] intValue];
                                  int said=[[object valueForKey:@"aid"] intValue];
                                  int ssid=[[object valueForKey:@"sid"] intValue];
                                  int spid=[[object valueForKey:@"pid"] intValue];
                                  //服务其中照片为空的那些个收支记录其实是有一张带麻子的照片
                                  //在iOS客户端中直接让record.photo指向空指针
                                  Photo *photo=nil;
                                  if(spid!=SYS_RECORD_PHOTO_NULL)
                                      photo=[dao.photoDao getBySid:[NSNumber numberWithInt:spid]];
                                  NSManagedObjectID *rid=[dao.recordDao saveWithSid:[NSNumber numberWithInt:srid]
                                                    andMoney:[NSNumber numberWithDouble:[[object valueForKey:@"money"] doubleValue]]
                                                   andRemark:[object valueForKey:@"remark"]
                                                     andTime:time
                                           andClassification:[dao.classificationDao getBySid:[NSNumber numberWithInt:scid]]
                                                  andAccount:[dao.accountDao getBySid:[NSNumber numberWithInt:said]]
                                                     andShop:[dao.shopDao getBySid:[NSNumber numberWithInt:ssid]]
                                                    andPhoto:photo
                                               inAccountBook:accountBook];
                                  if(DEBUG==1)
                                      NSLog(@"Create Record(rid=%@) in accountBook %@",rid,accountBook.abname);
                                  [self refreshConsole:[NSString stringWithFormat:@"Importing record created in %@ in account book: %@",
                                                        [dateFormatter stringFromDate:time],accountBook.abname]];
                              }
                              count++;
                              if(count==accountBooks.count)
                                  self.importUserInfoStatus++;
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Importing records failed. Server Error: %@",error);
                          }];
                }
                break;
            }
            case ImportUserInfoStatusTransfer: {
                if(DEBUG==1)
                    NSLog(@"Importing Transfers...");
                count=0;
                NSSet *accountBooks=importUser.accountBooks;
                for(AccountBook *accountBook in accountBooks) {
                    [manager POST:[InternetHelper createUrl:@"iOSTransferServlet?task=getTransfers"]
                       parameters:@{@"abid":accountBook.sid}
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              if(DEBUG==1)
                                  NSLog(@"Get message from server: %@",operation.responseString);
                              NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                              for(NSObject *object in objects) {
                                  long long timeInterval=[[object valueForKey:@"timeInterval"] longLongValue];
                                  NSDate *time=[NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
                                  int stfid=[[object valueForKey:@"tfid"] intValue];
                                  int stfoutid=[[object valueForKey:@"tfoutid"] intValue];
                                  int stfinid=[[object valueForKey:@"tfinid"] intValue];
                                  NSManagedObjectID *tfid=[dao.transferDao saveWithSid:[NSNumber numberWithInt:stfid]
                                                                              andMoney:[NSNumber numberWithDouble:[[object valueForKey:@"money"] doubleValue]]
                                                                             andRemark:[object valueForKey:@"remark"]
                                                                               andTime:time
                                                                         andOutAccount:[dao.accountDao getBySid:[NSNumber numberWithInt:stfoutid]]
                                                                          andInAccount:[dao.accountDao getBySid:[NSNumber numberWithInt:stfinid]]
                                                                         inAccountBook:accountBook];
                                  if(DEBUG==1)
                                      NSLog(@"Create Transfer(tfid=%@) in accountBook %@",tfid,accountBook.abname);
                                  [self refreshConsole:[NSString stringWithFormat:@"Importing transfer created in %@ in account book %@",
                                                        [dateFormatter stringFromDate:time],accountBook.abname]];
                              }
                              count++;
                              if(count==accountBooks.count)
                                  self.importUserInfoStatus++;
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Importing records failed. Server Error: %@",error);
                          }];
                }
                break;
            }
            case ImportUserInfoStatusAccountHistory: {
                if(DEBUG==1)
                    NSLog(@"Importing Account Histories...");
                count=0;
                int allAccountsCount=0;
                NSSet *accountBooks=importUser.accountBooks;
                for(AccountBook *accountBook in accountBooks)
                    allAccountsCount+=accountBook.accounts.count;
                //如果没有要导入的历史记录，直接跳过
                if(allAccountsCount==0)
                    self.importUserInfoStatus++;
                for(AccountBook *accountBook in accountBooks) {
                    for(Account *account in accountBook.accounts) {
                        [manager POST:[InternetHelper createUrl:@"iOSAccountHistoryServlet?task=getAccountHistories"]
                           parameters:@{@"aid":account.sid}
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
                                      NSDate *date=[NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
                                      NSManagedObjectID *ahid=[dao.accountHistoryDao saveBySid:[NSNumber numberWithInt:sahid]
                                                                                        andAin:[NSNumber numberWithDouble:ain]
                                                                                       andAout:[NSNumber numberWithDouble:aout]
                                                                                        onDate:date
                                                                                     inAccount:account];
                                      if(DEBUG==1)
                                        NSLog(@"Create AccountHistory(ahid=%@) in account %@",ahid,account.aname);
                                      [self refreshConsole:[NSString stringWithFormat:@"Importing account history on %@ in the account of %@",
                                                            [dateFormatter stringFromDate:date],account.aname]];
                                  }
                                  count++;
                                  if(count==allAccountsCount)
                                      self.importUserInfoStatus++;
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"Server Error: %@",error);
                              }];
                    }
                }
                break;
            }
            case ImportUserInfoStatusSynchronizationHistory:{
                [manager POST:[InternetHelper createUrl:@"iOSSynchronizeServlet?task=getSynchronizationHistories"]
                   parameters:@{@"uid":importUserUsid}
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          if(DEBUG==1)
                              NSLog(@"Get message from server: %@",operation.responseString);
                          NSArray *objects=[NSJSONSerialization JSONObjectWithData:responseObject
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:nil];
                          for(NSObject *object in objects) {
                              int sshid=[[object valueForKey:@"shid"] intValue];
                              NSString *device=[object valueForKey:@"device"];
                              NSString *ip=[object valueForKey:@"ip"];
                              long long timeInterval=[[object valueForKey:@"timeInterval"] longLongValue];
                              NSDate *time=[NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
                              int suid=[[object valueForKey:@"uid"] intValue];
                              User *user=[dao.userDao getBySid:[NSNumber numberWithInt:suid]];
                              NSManagedObjectID *ahid=[dao.synchronizationHistoryDao saveWithSid:[NSNumber numberWithInt:sshid]
                                                                                         andTime:time
                                                                                           andIP:ip
                                                                                       andDevice:device
                                                                                          inUser:user];
                              if(DEBUG==1)
                                  NSLog(@"Create SynchronizationHistory(ahid=%@) for user %@",ahid,user.uname);
                              [self refreshConsole:[NSString stringWithFormat:@"Importing synchronization history in %@",[dateFormatter stringFromDate:time]]];
                          }
                          self.importUserInfoStatus++;
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"Server Error:%@",error);
                      }];
                break;
            }
            case ImportUserInfoStatusEnd:
                
                //导入全部完成
                [self finishImport];
                break;
            default:
                break;
        }
    }
}

//刷新控制台消息
-(void)refreshConsole:(NSString *)message {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSString *text=[self.consoleTextView.text stringByAppendingFormat:@"\n%@",message];
    self.consoleTextView.text=text;
    [self.consoleTextView setContentOffset:CGPointMake(0, self.consoleTextView.contentSize.height)];
}

//导入全部完成
-(void)finishImport {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self refreshConsole:@"Import finished."];
    //关闭监听
    [self removeObserver:self forKeyPath:@"importUserInfoStatus"];
    //设置当前用户已登录
    [dao.userDao setUserLogin:YES withUid:importUser.objectID];
    //注册同步密钥
    Synchronization *sync=[[Synchronization alloc] init];
    [sync registSyncKey];
    //1s后跳转到主页面
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gotoMain) userInfo:nil repeats:NO];
}

//跳转到主页面
-(void)gotoMain {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self performSegueWithIdentifier:@"importUserInfoSuccessSegue" sender:self];
}

//没有任何作用，仅供论文说明
-(void)importUserData{
    //向服务器请求用户实体数据
    [manager POST:[InternetHelper createUrl:@"iOSUserServlet?task=getUser"]
       parameters:@{@"email":self.email}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //将服务器返回的json数据转化为Objective-C对象
              NSObject *object=[NSJSONSerialization
                         JSONObjectWithData:responseObject
                                    options:NSJSONReadingMutableContainers
                                      error:nil];
              //用户在服务其中的的物理id
              NSNumber *usid=[NSNumber numberWithInt:
                              [[object valueForKey:@"uid"] intValue]];
              //存储用户对象到iOS客户端数据库
              [dao.userDao saveWithEmail:[object valueForKey:@"email"]
                                andUname:[object valueForKey:@"uname"]
                             andPassword:[object valueForKey:@"password"]
                                  andSid:usid];
              //向服务其中请求用户的所有账本实体数据
              [manager POST:[InternetHelper
                    createUrl:@"iOSAccountBookServlet?task=getUserAccountBooks"]
                 parameters:@{@"uid":usid}
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        //处理AccountBook的导入
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Server Error: %@",error);
                    }];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Server Error: %@",error);
          }];
}

@end
