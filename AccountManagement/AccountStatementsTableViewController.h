//
//  AccountStatementsTableViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/27.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountStatementsTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *netAssetsLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalAssetsLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLibilities;
@end
