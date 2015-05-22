//
//  AddClassificationController.h
//  AccountManagement
//
//  Created by 李大爷 on 14/12/16.
//  Copyright (c) 2014年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddClassificationViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *selectedClassificationIconImageView;
@property (strong, nonatomic) IBOutlet UITextField *classificationNameTextField;
@property (strong, nonatomic) IBOutlet UICollectionView *classificationIconsCollectionView;

- (IBAction)finishEdit:(id)sender;
- (IBAction)saveClassification:(id)sender;

@end
