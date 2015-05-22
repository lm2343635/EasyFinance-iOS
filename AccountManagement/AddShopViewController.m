//
//  AddShopViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/7.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AddShopViewController.h"
#import "DaoManager.h"
#import "Util.h"

@interface AddShopViewController ()

@end

@implementation AddShopViewController {
    DaoManager *dao;
    NSArray *shopIcons;
    Icon *selectedShopIcon;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    shopIcons=[dao.iconDao findByType:IconTypeShop];
    selectedShopIcon=nil;
}

#pragma mark - View
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return shopIcons.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"shopIconCell" forIndexPath:indexPath];
    UIImageView *shopIconImageView=(UIImageView *)[cell viewWithTag:1];
    shopIconImageView.image=[UIImage imageWithData:[[shopIcons objectAtIndex:indexPath.row] idata]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    selectedShopIcon=[shopIcons objectAtIndex:indexPath.row];
    self.selectedShopIconImageView.image=[UIImage imageWithData:selectedShopIcon.idata];
}

#pragma mark - Action
- (IBAction)finishEdit:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [sender resignFirstResponder];
}

- (IBAction)saveShop:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self.shopNameTextField resignFirstResponder];
    NSString *shopName=self.shopNameTextField.text;
    if(shopIcons==nil||[shopName isEqualToString:@""]) {
        [Util showAlert:@"Please input shop name and choose an icon for it."];
    }else{
        AccountBook *usingAccountBook=[dao.userDao getLoginedUser].usingAccountBook;
        NSManagedObjectID *sid=[dao.shopDao saveWithAccountBook:usingAccountBook
                                                       andSname:shopName
                                                       andSicon:selectedShopIcon];
        if(DEBUG==1)
            NSLog(@"Create shop(sid=%@) in accountBook %@",sid,usingAccountBook.abname);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
