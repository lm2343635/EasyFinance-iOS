//
//  RecordViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/18.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "RecordViewController.h"
#import "PhotoViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController {
    DaoManager *dao;
    AFHTTPRequestOperationManager *manager;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    manager=[InternetHelper getRequestOperationManager];
    [self loadRecordPhoto];
    self.moneyTextFeild.text=[self.record.money stringValue];
    [self.selectClassificationButton setTitle:self.record.classification.cname
                                     forState:UIControlStateNormal];
    self.selectClassificationIconImageView.image=[UIImage imageWithData:self.record.classification.cicon.idata];
    [self.selectAccountButton setTitle:self.record.account.aname
                              forState:UIControlStateNormal];
    self.selectAccountIconImageView.image=[UIImage imageWithData:self.record.account.aicon.idata];
    [self.selectShopButton setTitle:self.record.shop.sname
                           forState:UIControlStateNormal];
    self.selectShopIconImageView.image=[UIImage imageWithData:self.record.shop.sicon.idata];
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [self.selectTimeButton setTitle:[dateFormatter stringFromDate:self.record.time]
                           forState:UIControlStateNormal];
    self.remarkTextView.text=self.record.remark;
}




#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"recordPhotoSegue"]) {
        PhotoViewController *controller=(PhotoViewController *)[segue destinationViewController];
        controller.image=[UIImage imageWithData:self.record.photo.pdata];
    }
}


#pragma mark - Action
- (IBAction)back:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Service
//加载收支记录照片
-(void)loadRecordPhoto {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if(self.record.photo!=nil) {
        //该照片已经下载过就不用下载了
        if(self.record.photo.pdata!=nil) {
            [self.takePhotoButton setImage:[UIImage imageWithData:self.record.photo.pdata]
                                  forState:UIControlStateNormal];
        } else {
            [self.takePhotoButton setImage:[UIImage imageWithData:nil]
                                  forState:UIControlStateNormal];
            [self.downloadPhotoActivityIndicator startAnimating];
            [NSThread detachNewThreadSelector:@selector(downloadPhoto:) toTarget:self withObject:self.record.photo];
        }
    }
}

//在后台线程中对照品
-(void)downloadPhoto:(Photo *)photo {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [manager POST:[InternetHelper createUrl:@"iOSPhotoServlet?task=getPhotoFilePath"]
       parameters:@{@"pid":photo.sid}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if(DEBUG==1)
                  NSLog(@"Get message from server: %@",operation.responseString);
              NSURL *url=[NSURL URLWithString:[InternetHelper createUrl:operation.responseString]];
              //下载图片
              photo.pdata=[[NSData alloc] initWithContentsOfURL:url];
              //保存图片
              [dao.cdh saveContext];
              [self.takePhotoButton setImage:[UIImage imageWithData:photo.pdata]
                                    forState:UIControlStateNormal];
              [self.downloadPhotoActivityIndicator stopAnimating];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Server Error: %@",error);
          }];
}
@end
