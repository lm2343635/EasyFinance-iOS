//
//  AddTransferController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/1/14.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTransferViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *moneyTextField;
@property (strong, nonatomic) IBOutlet UIButton *selectOutAccountButton;
@property (strong, nonatomic) IBOutlet UIImageView *selectOutAccountImageView;
@property (strong, nonatomic) IBOutlet UIButton *selectInAccountButton;
@property (strong, nonatomic) IBOutlet UIImageView *selectInAccountImageView;
@property (strong, nonatomic) IBOutlet UIButton *selectTimeButton;
@property (strong, nonatomic) IBOutlet UITextView *remarkTextView;

- (IBAction)closeAddTransfer:(id)sender;
- (IBAction)saveTransfer:(id)sender;

@end
