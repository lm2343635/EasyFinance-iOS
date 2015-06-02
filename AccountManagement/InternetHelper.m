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

+(NSInteger)testNetStatus {
    if(DEBUG==1)
        NSLog(@"Running InternetHelper '%@'",NSStringFromSelector(_cmd));
//    Reachability *reach=[Reachability reachabilityWithHostName:@"baidu.com"];
//    return [reach currentReachabilityStatus];
    return ReachableViaWiFi;
}

+(NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

+(NSString *)getDeviceInfo {
    //iOS设备信息
    NSString *iOSDeviceInfo=[NSString stringWithFormat:@"%@ iOS %@",
                             [[UIDevice currentDevice] name],
                             [[UIDevice currentDevice] systemVersion]];
    return iOSDeviceInfo;
}
@end
