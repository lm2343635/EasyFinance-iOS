//
//  MainController.h
//  AccountManagement
//
//  Created by 李大爷 on 14/12/17.
//  Copyright (c) 2014年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *timeInformation;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UILabel *usingAccountBookLabel;
@property (strong, nonatomic) IBOutlet UIImageView *usingAccountBookImageView;
@property (strong, nonatomic) IBOutlet UIImageView *userPhotoImageView;


- (IBAction)closeMemu:(UIPanGestureRecognizer *)sender;

@end
