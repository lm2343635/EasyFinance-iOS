//
//  InternetHelper.m
//  AccountManagement
//
//  Created by 李大爷 on 15/4/29.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "InternetHelper.h"

@implementation InternetHelper

+ (AFHTTPRequestOperationManager *)getRequestOperationManager {
    if(DEBUG==1)
        NSLog(@"Running InternetHelper '%@'",NSStringFromSelector(_cmd));
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    return delegate.manager;
}

+ (NSString *)createUrl:(NSString *)relativePosition {
    NSString *url=[NSString stringWithFormat:@"http://%@/%@",Domain,relativePosition];
    if(DEBUG==1) {
        NSLog(@"Running InternetHelper '%@'",NSStringFromSelector(_cmd));
        NSLog(@"Request URL is: %@",url);
    }
    return url;
}

+ (NSInteger)testNetStatus {
    if(DEBUG==1)
        NSLog(@"Running InternetHelper '%@'",NSStringFromSelector(_cmd));
    Reachability *reach=[Reachability reachabilityWithHostName:InteretTestDomain];
    return [reach currentReachabilityStatus];
}

+ (NSString *)getDeviceInfo {
    //iOS设备信息
    NSString *iOSDeviceInfo=[NSString stringWithFormat:@"%@ iOS %@",
                             [[UIDevice currentDevice] name],
                             [[UIDevice currentDevice] systemVersion]];
    return iOSDeviceInfo;
}

+ (void)getLANIPAddressWithCompletion:(void (^)(NSString *IPAddress))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *IP = [self getIPAddress];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(IP);
            }
        });
    });
}

+ (void)getWANIPAddressWithCompletion:(void(^)(NSString *IPAddress))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *IP = @"0.0.0.0";
        NSURL *url = [NSURL URLWithString:@"http://ifconfig.me/ip"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:8.0];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            NSLog(@"Failed to get WAN IP Address!\n%@", error);
            [[[UIAlertView alloc] initWithTitle:@"获取外网 IP 地址失败" message:[error localizedFailureReason] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            IP = responseStr;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(IP);
        });
    });
}

+ (NSString *)getIPAddress
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
@end
