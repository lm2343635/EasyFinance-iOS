//
//  TransferViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/24.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoManager.h"

@interface TransferViewController : UIViewController

@property (strong, nonatomic) Transfer *transfer;

@property (strong, nonatomic) IBOutlet UITextField *moneyTextField;
@property (strong, nonatomic) IBOutlet UIButton *selectOutAccountButton;
@property (strong, nonatomic) IBOutlet UIImageView *selectOutAccountImageView;
@property (strong, nonatomic) IBOutlet UIButton *selectInAccountButton;
@property (strong, nonatomic) IBOutlet UIImageView *selectInAccountImageView;
@property (strong, nonatomic) IBOutlet UIButton *selectTimeButton;
@property (strong, nonatomic) IBOutlet UITextView *remarkTextView;

@end
