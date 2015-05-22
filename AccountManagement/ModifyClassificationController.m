//
//  ModifyClassificationController.m
//  AccountManagement
//
//  Created by 李大爷 on 14/12/16.
//  Copyright (c) 2014年 李大爷. All rights reserved.
//

#import "ModifyClassificationController.h"

@interface ModifyClassificationController ()

@end

@implementation ModifyClassificationController
{
    NSArray *classificationIconImages;
    BOOL isModifying;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=self.classificationName;
    self.classificationIconImageView.image=[UIImage imageNamed:self.classificationIcon];
    self.classifationNameLabel.text=self.classificationName;
    isModifying=NO;
    classificationIconImages=[NSArray arrayWithObjects:@"d_cfsb",
                              @"d_ctjj",@"d_fscl",@"d_hsfz",
                              @"d_db",@"d_dhdsjwlxl",@"d_hsfz",@"d_fd",
                              @"d_dhdsjwlxl",@"d_fscl",@"d_hsfz",
                              @"d_dlgzcl",@"d_fscl",@"d_hsfz",@"d_fd",
                              @"d_dy",@"d_fscl",@"d_hsfz",@"d_fd",
                              @"d_fd",@"d_fscl",@"d_fscl",@"d_dlgzcl",
                              @"d_fjp",@"d_dhdsjwlxl",@"d_fscl",@"d_fscl",
                              @"d_fscl",@"d_fscl",@"d_hsfz",
                              @"d_fzcl",@"d_dhdsjwlxl",@"d_hsfz",
                              @"d_fzsb",@"d_hsfz",@"d_dlgzcl",
                              @"d_hlqt",@"d_dhdsjwlxl",@"d_dlgzcl",@"d_dlgzcl",
                              @"d_hsfz",@"d_fscl",@"d_dlgzcl",
                              @"d_hqhdfy",@"d_fscl",@"d_dlgzcl",
                              @"d_hssy",nil];
}

- (IBAction)finishEdit:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)modifyClassification:(UIBarButtonItem *)sender
{
    if(!isModifying)
    {
        sender.image=[UIImage imageNamed:@"setting_modify_save"];
        self.classifationNameLabel.hidden=YES;
        self.classificationNameField.hidden=NO;
        self.classificationIconsCollection.hidden=NO;
        isModifying=YES;
    }
    else
    {
        sender.image=[UIImage imageNamed:@"setting_modify"];
        //此处保存更改到数据库
        
        self.classifationNameLabel.text=self.classificationNameField.text;
        self.classificationNameField.text=@"";
        self.classifationNameLabel.hidden=NO;
        self.classificationNameField.hidden=YES;
        self.classificationIconsCollection.hidden=YES;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"classificationIconCell";
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.layer.masksToBounds=YES;
    NSInteger rowNo=indexPath.row;
    UIImageView *imageView=(UIImageView *)[cell viewWithTag:1];
    imageView.image=[UIImage imageNamed:[classificationIconImages objectAtIndex:rowNo]];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return classificationIconImages.count;
}
@end
