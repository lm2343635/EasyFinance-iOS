//
//  AddTemplateViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/8.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoManager.h"
#import "SelectorView.h"

@interface AddTemplateViewController : UIViewController

@property (strong, nonatomic) IBOutlet SelectorView *selectorView;

@property (strong, nonatomic) IBOutlet UITextField *templateNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *selectClassificationButton;
@property (strong, nonatomic) IBOutlet UIImageView *selectClassificationIconImageView;
@property (strong, nonatomic) IBOutlet UIButton *selectAccountButton;
@property (strong, nonatomic) IBOutlet UIImageView *selectAccountIconImageView;
@property (strong, nonatomic) IBOutlet UIButton *selectShopButton;
@property (strong, nonatomic) IBOutlet UIImageView *selectShopIconImageView;

- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)finishEdit:(id)sender;

- (IBAction)selectClassification:(id)sender;
- (IBAction)selectAccount:(id)sender;
- (IBAction)selectShop:(id)sender;

- (IBAction)saveTemplate:(id)sender;

@end
