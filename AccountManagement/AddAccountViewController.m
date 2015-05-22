//
//  AddAccountViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/7.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AddAccountViewController.h"
#import "DaoManager.h"
#import "Util.h"

@interface AddAccountViewController ()

@end

@implementation AddAccountViewController {
    DaoManager *dao;
    NSArray *accountIcons;
    Icon *selectedAccountIcon;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    accountIcons=[dao.iconDao findByType:IconTypeAccount];
    selectedAccountIcon=nil;
}

#pragma mark - View
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return accountIcons.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"accountIconCell"
                                                                         forIndexPath:indexPath];
    UIImageView *accountIconImageView=(UIImageView *)[cell viewWithTag:1];
    accountIconImageView.image=[UIImage imageWithData:[[accountIcons objectAtIndex:indexPath.row] idata]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    selectedAccountIcon=[accountIcons objectAtIndex:indexPath.row];
    self.selectedAccountIconImageView.image=[UIImage imageWithData:selectedAccountIcon.idata];
}

#pragma mark - Action
- (IBAction)finishEdit:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [sender resignFirstResponder];
}

- (IBAction)saveAccount:(id)sender {
    [self.accountNameTextField resignFirstResponder];
    NSString *accountName=self.accountNameTextField.text;
    NSString *accountAssetStr=self.accountAssetTextField.text;
    if(selectedAccountIcon==nil||[accountName isEqualToString:@""]||[accountAssetStr isEqualToString:@""]) {
        [Util showAlert:@"Please input account name and choose an icon for it."];
    }else{
        AccountBook *usingAccountBook=[dao.userDao getLoginedUser].usingAccountBook;
        NSManagedObjectID *aid=[dao.accountDao saveWithAccountBook:usingAccountBook
                                                          andAname:accountName
                                                          andAicon:selectedAccountIcon
                                                            andAin:[NSNumber numberWithDouble:[accountAssetStr doubleValue]]];
        if(DEBUG==1)
            NSLog(@"Create account(aid=%@) in accountBook %@",aid,usingAccountBook.abname);
        [self.navigationController popViewControllerAnimated:YES];
}
}
@end
