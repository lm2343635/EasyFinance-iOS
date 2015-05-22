//
//  CreateAccountBookViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/4/29.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoManager.h"

#define AccountBookCellIcon 1
#define AccountBookCellSelectedIcon 2

@interface CreateAccountBookViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>

//用户邮箱，作为创建账本的凭据
@property (strong, nonatomic) NSString *email;

@property (strong, nonatomic) IBOutlet UITextField *accountBookNameTextField;
@property (strong, nonatomic) IBOutlet UICollectionView *accountBookIconsCollectionView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *saveAccountBookActivityIndicatorView;
@property (strong, nonatomic) IBOutlet UIButton *saveAccountBookButton;

- (IBAction)finishEdit:(id)sender;
- (IBAction)saveAccountBook:(id)sender;

@end
