//
//  PhotoViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/22.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;

- (IBAction)back:(id)sender;

@end
