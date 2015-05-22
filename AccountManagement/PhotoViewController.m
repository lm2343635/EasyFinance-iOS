//
//  PhotoViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/22.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    self.photoImageView.image=self.image;
    self.photoImageView.contentMode=UIViewContentModeScaleAspectFit;
}

#pragma mark - Action
- (IBAction)back:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
