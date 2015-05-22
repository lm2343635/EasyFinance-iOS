//
//  AddAccountViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/7.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAccountViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *selectedAccountIconImageView;
@property (strong, nonatomic) IBOutlet UITextField *accountNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *accountAssetTextField;
@property (strong, nonatomic) IBOutlet UICollectionView *accountIconsCollectionView;

- (IBAction)finishEdit:(id)sender;
- (IBAction)saveAccount:(id)sender;

@end
