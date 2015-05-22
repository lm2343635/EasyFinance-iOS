//
//  RecordViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/18.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemInit.h"

@interface RecordViewController : UIViewController

@property (nonatomic,strong) Record *record;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *downloadPhotoActivityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (strong, nonatomic) IBOutlet UITextField *moneyTextFeild;
@property (strong, nonatomic) IBOutlet UIButton *selectClassificationButton;
@property (strong, nonatomic) IBOutlet UIImageView *selectClassificationIconImageView;
@property (strong, nonatomic) IBOutlet UIButton *selectAccountButton;
@property (strong, nonatomic) IBOutlet UIImageView *selectAccountIconImageView;
@property (strong, nonatomic) IBOutlet UIButton *selectShopButton;
@property (strong, nonatomic) IBOutlet UIImageView *selectShopIconImageView;

@property (strong, nonatomic) IBOutlet UIButton *selectTimeButton;
@property (strong, nonatomic) IBOutlet UITextView *remarkTextView;

- (IBAction)back:(id)sender;
@end
