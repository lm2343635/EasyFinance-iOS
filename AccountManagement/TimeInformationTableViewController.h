//
//  TimeInformationTableViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/6/5.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeInformationTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *surplusLabel;
@property (strong, nonatomic) IBOutlet UILabel *earnLabel;
@property (strong, nonatomic) IBOutlet UILabel *spendLabel;

- (IBAction)back:(id)sender;

@end
