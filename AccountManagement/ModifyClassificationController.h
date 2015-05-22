//
//  ModifyClassificationController.h
//  AccountManagement
//
//  Created by 李大爷 on 14/12/16.
//  Copyright (c) 2014年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyClassificationController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong,nonatomic) NSString *classificationName;
@property (strong,nonatomic) NSString *classificationIcon;
@property (strong, nonatomic) IBOutlet UIImageView *classificationIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *classifationNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *classificationNameField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *modifyClassificationButton;
@property (strong, nonatomic) IBOutlet UICollectionView *classificationIconsCollection;

- (IBAction)finishEdit:(id)sender;
- (IBAction)modifyClassification:(UIBarButtonItem *)sender;
@end
