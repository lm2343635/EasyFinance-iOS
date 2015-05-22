//
//  AddAccountBookViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/4/16.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AddAccountBookViewController.h"
#import "DaoManager.h"
#import "Util.h"

@interface AddAccountBookViewController ()

@end

@implementation AddAccountBookViewController {
    DaoManager *dao;
    User *loginedUser;
    NSArray *accountBookIcons;
    Icon *choosedAccountBookIcon;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    loginedUser=[dao.userDao getLoginedUser];
    //获取所有账本图标
    accountBookIcons=[dao.iconDao findByType:IconTypeAccountBook];
    //用第一个账本图标作为默认被选中的账本图标
    choosedAccountBookIcon=[accountBookIcons objectAtIndex:0];
    self.choosedIconImageView.image=[UIImage imageWithData:choosedAccountBookIcon.idata];
}

#pragma mark - VIEW
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return accountBookIcons.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    static NSString *cellIdentifier=@"accountBookIconCell";
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.layer.masksToBounds=YES;
    UIImageView *imageView=(UIImageView *)[cell viewWithTag:1];
    imageView.image=[UIImage imageWithData:[[accountBookIcons objectAtIndex:indexPath.row] idata]];
    return cell;
}

#pragma mark - DELEGATE
//ColloectionView被选中调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    choosedAccountBookIcon=[accountBookIcons objectAtIndex:indexPath.row];
    self.choosedIconImageView.image=[UIImage imageWithData:choosedAccountBookIcon.idata];
}

#pragma mark - ACTION
//保存新增的账本
- (IBAction)save:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSString *accountBookName=self.accountBookNameTextFeild.text;
    if([accountBookName isEqualToString:@""]){
        [Util showAlert:@"Please input account book name."];
    }else{
        [dao.accountBookDao saveWithName:accountBookName
                                 andIcon:choosedAccountBookIcon
                                 andUser:loginedUser];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//完成编辑后关闭当前激活的虚拟键盘
- (IBAction)editFinish:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [sender resignFirstResponder];
}


@end
