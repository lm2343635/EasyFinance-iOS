//
//  Util.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/4.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "Util.h"

@implementation Util {
    id accessorySender;
}

+(void)showAlert:(NSString *)message {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Tip"
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
    [alert show];
}

@end
