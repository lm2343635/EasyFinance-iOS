//
//  InternetHelper.m
//  AccountManagement
//
//  Created by 李大爷 on 15/4/29.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "InternetHelper.h"

@implementation InternetHelper

+(AFHTTPRequestOperationManager *)getRequestOperationManager {
    if(DEBUG==1)
        NSLog(@"Running InternetHelper '%@'",NSStringFromSelector(_cmd));
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    return delegate.manager;
}

+(NSString *)createUrl:(NSString *)relativePosition {
    NSString *url=[NSString stringWithFormat:@"http://%@/%@/%@",Server,WebServiceName,relativePosition];
    if(DEBUG==1) {
        NSLog(@"Running InternetHelper '%@'",NSStringFromSelector(_cmd));
        NSLog(@"Request URL is: %@",url);
    }
    return url;
}

@end
