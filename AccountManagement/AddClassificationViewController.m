//
//  AddClassificationController.m
//  AccountManagement
//
//  Created by 李大爷 on 14/12/16.
//  Copyright (c) 2014年 李大爷. All rights reserved.
//

#import "AddClassificationViewController.h"
#import "DaoManager.h"
#import "Util.h"

@implementation AddClassificationViewController {
    DaoManager *dao;
    NSArray *classificationIcons;
    Icon *selectedClassificationIcon;
}

- (void)viewDidLoad{
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    classificationIcons=[dao.iconDao findByType:IconTypeClassification];
    selectedClassificationIcon=nil;
}

#pragma mark - View
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return classificationIcons.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1&&CELL_AT_INDEX_PATH_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"classificationIconCell"
                                                                         forIndexPath:indexPath];
    cell.layer.masksToBounds=YES;
    UIImageView *classificationIconImageView=(UIImageView *)[cell viewWithTag:1];
    classificationIconImageView.image=[UIImage imageWithData:[[classificationIcons objectAtIndex:indexPath.row] idata]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    selectedClassificationIcon=[classificationIcons objectAtIndex:indexPath.row];
    self.selectedClassificationIconImageView.image=[UIImage imageWithData:selectedClassificationIcon.idata];
}


#pragma mark - Action
- (IBAction)finishEdit:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [sender resignFirstResponder];
}

//保存分类
- (IBAction)saveClassification:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //关闭键盘
    [self.classificationNameTextField resignFirstResponder];
    NSString *classificationName=self.classificationNameTextField.text;
    if(selectedClassificationIcon==nil||[classificationName isEqualToString:@""])
        [Util showAlert:@"Please input classification name and choose an icon for it."];
    else {
        AccountBook *usingAccountBook=[dao.userDao getLoginedUser].usingAccountBook;
        NSManagedObjectID *cid=[dao.classificationDao saveWithAccountBook:usingAccountBook
                                                                 andCname:classificationName
                                                                 andCicon:selectedClassificationIcon];
        if(DEBUG==1)
            NSLog(@"Create classification(cid=%@) in accountBook %@",cid,usingAccountBook.abname);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
