//
//  AddShopViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/7.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddShopViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *selectedShopIconImageView;
@property (strong, nonatomic) IBOutlet UITextField *shopNameTextField;
@property (strong, nonatomic) IBOutlet UICollectionView *shopIconsCollectionView;

- (IBAction)finishEdit:(id)sender;
- (IBAction)saveShop:(id)sender;

@end
