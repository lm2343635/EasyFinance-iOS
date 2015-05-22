//
//  LatestRecordTableViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/18.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LatestRecordTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *usingAccountBookNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userPhotoImageView;


- (IBAction)back:(id)sender;

@end
