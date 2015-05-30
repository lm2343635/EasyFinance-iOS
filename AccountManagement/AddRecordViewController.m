//
//  AddRecordViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/10.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AddRecordViewController.h"

@interface AddRecordViewController ()

@end

@implementation AddRecordViewController {
    //拍照控制器
    UIImagePickerController *imagePickerController;
    NSArray *classifications;
    NSArray *accounts;
    NSArray *shops;
    NSArray *templates;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    imagePickerController=[[UIImagePickerController alloc] init];
    imagePickerController.delegate=self;
    self.dao=[[DaoManager alloc] init];
    self.loginedUser=[self.dao.userDao getLoginedUser];
    AccountBook *usingAccountBook=self.loginedUser.usingAccountBook;
    classifications=[self.dao.classificationDao findByAccountBook:usingAccountBook];
    accounts=[self.dao.accountDao findByAccountBook:usingAccountBook];
    shops=[self.dao.shopDao findByAccoutBook:usingAccountBook];
    templates=[self.dao.templateDao findByAccountBook:usingAccountBook];
    self.selectedClassification=nil;
    self.selectedAccount=nil;
    self.selectedShop=nil;
    //设置选择按钮文本为当前时间
    [self setTime:[[NSDate alloc] init]];
    self.photoImage=nil;
    //给文本域设置关闭虚拟键盘的附件
    [self setCloseKeyboardAccessoryForSender:self.remarkTextView];
    [self setCloseKeyboardAccessoryForSender:self.moneyTextFeild];
};


#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    CGRect frame = textView.frame;
    int offset=frame.origin.y+textView.frame.size.height-(self.view.frame.size.height-KeyboardHeight);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame=CGRectMake(0.0f,-offset,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    switch (buttonIndex) {
        case TakePhotoActionSheetCameraIndex:
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                // 将sourceType设为UIImagePickerControllerSourceTypeCamera代表拍照或拍视频
                imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
                // 设置模式为拍摄照片
                imagePickerController.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
                // 设置使用手机的后置摄像头（默认使用后置摄像头）
                imagePickerController.cameraDevice=UIImagePickerControllerCameraDeviceRear;
                // 设置拍摄的照片允许编辑
                imagePickerController.allowsEditing=YES;
            }else{
                NSLog(@"iOS Simulator cannot open camera.");
                [Util showAlert:@"iOS Simulator cannot open camera."];
            }
            
            break;
        case TakePhotoActionSheetPhtotLibraryIndex:
            // 设置选择载相册的图片
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.allowsEditing = YES;
            break;
        default:
            break;
    }
    // 显示picker视图控制器
    [self presentViewController:imagePickerController animated: YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if(DEBUG==1) {
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
        NSLog(@"MediaInfo: %@",info);
    }
    // 获取用户拍摄的是照片还是视频
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        self.photoImage=[info objectForKey:UIImagePickerControllerEditedImage];
        [self.takePhotoButton setImage:self.photoImage forState:UIControlStateNormal];
    }
    // 隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action
- (IBAction)closeRecord:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectClassification:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self.selectorView initWithSelectorData:classifications
                       andIconAttributeName:@"cicon"
                   andIconDataAttributeName:@"idata"
                       andNameAttributeName:@"cname"
                               withCallback:^(NSObject *object) {
                                   [self setClassification:(Classification *)object];
                               }];
}

- (IBAction)selectAccount:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self.selectorView initWithSelectorData:accounts
                       andIconAttributeName:@"aicon"
                   andIconDataAttributeName:@"idata"
                       andNameAttributeName:@"aname"
                               withCallback:^(NSObject *object) {
                                   [self setAccount:(Account *)object];
                               }];
}

- (IBAction)selectShop:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self.selectorView initWithSelectorData:shops
                       andIconAttributeName:@"sicon"
                   andIconDataAttributeName:@"idata"
                       andNameAttributeName:@"sname"
                               withCallback:^(NSObject *object) {
                                   [self setShop:(Shop *)object];
                               }];
}

- (IBAction)chooseTemplate:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self.selectorView initWithSelectorData:templates
                       andNameAttributeName:@"tpname"
                               withCallback:^(NSObject *object) {
                                   Template *template=(Template *)object;
                                   [self setClassification:template.classification];
                                   [self setAccount:template.account];
                                   [self setShop:template.shop];
                               }];
}

- (IBAction)selectTime:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self.dateSelectorView initWithCallback:^(NSObject *object) {
        [self setTime:(NSDate *)object];
    }];
}

- (IBAction)takePhoto:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"Choose photo from"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"Camera",@"Photo Library", nil];
    [sheet showInView:self.view];
}

#pragma mark - Service
-(void)setClassification:(Classification *)classification {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    self.selectedClassification=classification;
    UIImage *image=[UIImage imageWithData:self.selectedClassification.cicon.idata];
    self.selectClassificationIconImageView.image=image;
    [self.selectClassificationButton setTitle:self.selectedClassification.cname
                                     forState:UIControlStateNormal];
}

-(void)setAccount:(Account *)account {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    self.selectedAccount=account;
    UIImage *image=[UIImage imageWithData:self.selectedAccount.aicon.idata];
    self.selectAccountIconImageView.image=image;
    [self.selectAccountButton setTitle:self.selectedAccount.aname
                              forState:UIControlStateNormal];
}

-(void)setShop:(Shop *)shop {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    self.selectedShop=shop;
    UIImage *image=[UIImage imageWithData:self.selectedShop.sicon.idata];
    self.selectShopIconImageView.image=image;
    [self.selectShopButton setTitle:self.selectedShop.sname
                              forState:UIControlStateNormal];
}

-(void)setTime:(NSDate *)time {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    self.selectedTime=time;
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *timeString = [dateFormatter stringFromDate:self.selectedTime];
    [self.selectTimeButton setTitle:timeString
                           forState:UIControlStateNormal];
}

-(void)setCloseKeyboardAccessoryForSender:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    // 创建一个UIToolBar工具条
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    // 设置工具条风格
    [topView setBarStyle:UIBarStyleDefault];
    // 为工具条创建第2个“按钮”，该按钮只是一片可伸缩的空白区。
    UIBarButtonItem* spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                     target:self
                                                                                     action:nil];
    // 为工具条创建第3个“按钮”，单击该按钮会激发editFinish方法
    UIBarButtonItem *doneButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:@selector(editFinish)];
    
    // 以3个按钮创建NSArray集合
    NSArray * buttonsArray = [NSArray arrayWithObjects:spaceButtonItem,doneButtonItem,nil];
    // 为UIToolBar设置按钮
    [topView setItems:buttonsArray];
    [sender setInputAccessoryView:topView];
}

//键盘完成输入后关闭
-(void)editFinish {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if([self.remarkTextView isFirstResponder])
        [self.remarkTextView resignFirstResponder];
    else if ([self.moneyTextFeild isFirstResponder])
        [self.moneyTextFeild resignFirstResponder];
}

//检查提交合法性
-(BOOL)recordSubmitValidate {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if(self.selectedAccount==nil||self.selectedClassification==nil||self.selectedShop==nil) {
        [Util showAlert:@"Please select classification, account and shop before you save the record."];
        return NO;
    }
    return YES;
}
@end
