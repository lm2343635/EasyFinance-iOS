//
//  AddAccountBookViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/4/16.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAccountBookViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *choosedIconImageView;
@property (strong, nonatomic) IBOutlet UITextField *accountBookNameTextFeild;

- (IBAction)save:(id)sender;
- (IBAction)editFinish:(id)sender;

@end
