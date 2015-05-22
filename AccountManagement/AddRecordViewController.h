//
//  AddRecordViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/10.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoManager.h"
#import "Util.h"
#import "SelectorView.h"
#import "DateSelectorView.h"

#define TakePhotoActionSheetCameraIndex 0
#define TakePhotoActionSheetPhtotLibraryIndex 1

//AddEarnViewController和AddSpendViewController的父类
@interface AddRecordViewController : UIViewController <UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) DaoManager *dao;
@property (strong, nonatomic) User *loginedUser;
@property (strong, nonatomic) Classification *selectedClassification;
@property (strong, nonatomic) Account *selectedAccount;
@property (strong, nonatomic) Shop *selectedShop;
@property (strong, nonatomic) NSDate *selectedTime;
@property (strong, nonatomic) UIImage *photoImage;

@property (strong, nonatomic) IBOutlet SelectorView *selectorView;
@property (strong, nonatomic) IBOutlet DateSelectorView *dateSelectorView;

@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (strong, nonatomic) IBOutlet UITextField *moneyTextFeild;
@property (strong, nonatomic) IBOutlet UIButton *selectClassificationButton;
@property (strong, nonatomic) IBOutlet UIImageView *selectClassificationIconImageView;
@property (strong, nonatomic) IBOutlet UIButton *selectAccountButton;
@property (strong, nonatomic) IBOutlet UIImageView *selectAccountIconImageView;
@property (strong, nonatomic) IBOutlet UIButton *selectShopButton;
@property (strong, nonatomic) IBOutlet UIImageView *selectShopIconImageView;
@property (strong, nonatomic) IBOutlet UIButton *chooseTemplateButton;
@property (strong, nonatomic) IBOutlet UIButton *selectTimeButton;
@property (strong, nonatomic) IBOutlet UITextView *remarkTextView;

- (IBAction)closeRecord:(id)sender;
- (IBAction)selectClassification:(id)sender;
- (IBAction)selectAccount:(id)sender;
- (IBAction)selectShop:(id)sender;
- (IBAction)chooseTemplate:(id)sender;
- (IBAction)selectTime:(id)sender;
- (IBAction)takePhoto:(id)sender;

//检查提交合法性
-(BOOL)recordSubmitValidate;

@end
