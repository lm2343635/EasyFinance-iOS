//
//  LeftMenuViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/25.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *usingAccountBookLabel;
@property (strong, nonatomic) IBOutlet UIImageView *usingAccountBookImageView;
@property (strong, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (strong, nonatomic) IBOutlet UICollectionView *accountBooksCollectionView;

- (IBAction)synchronize:(id)sender;
@end
