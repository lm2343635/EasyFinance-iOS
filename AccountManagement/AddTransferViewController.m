//
//  AddTransferController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/1/14.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AddTransferViewController.h"
#import "DaoManager.h"
#import "Util.h"

@interface AddTransferViewController ()

@end

@implementation AddTransferViewController {
    DaoManager *dao;
    User *loginedUser;
    NSArray *accounts;
    Account *selectedOutAccount;
    Account *selectedInAccount;
    NSDate *selectedTime;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    loginedUser=[dao.userDao getLoginedUser];
    accounts=[loginedUser.usingAccountBook.accounts allObjects];
    [self setTime:[[NSDate alloc] init]];
    [self setCloseKeyboardAccessoryForSender:self.remarkTextView];
    [self setCloseKeyboardAccessoryForSender:self.moneyTextField];
}

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

#pragma mark - Action
- (IBAction)closeAddTransfer:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveTransfer:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if(selectedOutAccount==nil||selectedInAccount==nil)
        [Util showAlert:@"Please select accounts before you save the transfer."];
    else {
        NSNumber *money=[NSNumber numberWithDouble:[self.moneyTextField.text doubleValue]];
        NSString *remark=self.remarkTextView.text;
        NSManagedObjectID *tfid=[dao.transferDao saveWithMoney:money
                                                     andRemark:remark
                                                       andTime:selectedTime
                                                 andOutAccount:selectedOutAccount
                                                  andInAccount:selectedInAccount
                                                 inAccountBook:loginedUser.usingAccountBook];
        if(DEBUG==1)
            NSLog(@"Create transfer(tfid=%@) in accountBook %@",tfid,loginedUser.usingAccountBook.abname);
        if(tfid)
            [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)selectOutAccount:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self.selectorView initWithSelectorData:accounts
                       andIconAttributeName:@"aicon"
                   andIconDataAttributeName:@"idata"
                       andNameAttributeName:@"aname"
                               withCallback:^(NSObject *object) {
                                   [self setOutAccount:(Account *)object];
                               }];
}

- (IBAction)selectInAccount:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self.selectorView initWithSelectorData:accounts
                       andIconAttributeName:@"aicon"
                   andIconDataAttributeName:@"idata"
                       andNameAttributeName:@"aname"
                               withCallback:^(NSObject *object) {
                                   [self setInAccount:(Account *)object];
                               }];
}

- (IBAction)selectTime:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self.dateSelectorView initWithCallback:^(NSObject *object) {
        [self setTime:(NSDate *)object];
    }];
}

#pragma mark - Service
-(void)setOutAccount:(Account *)account {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    selectedOutAccount=account;
    self.selectOutAccountImageView.image=[UIImage imageWithData:selectedOutAccount.aicon.idata];
    [self.selectOutAccountButton setTitle:selectedOutAccount.aname
                                 forState:UIControlStateNormal];
}

-(void)setInAccount:(Account *)account {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    selectedInAccount=account;
    self.selectInAccountImageView.image=[UIImage imageWithData:selectedInAccount.aicon.idata];
    [self.selectInAccountButton setTitle:selectedInAccount.aname
                                 forState:UIControlStateNormal];
}

-(void)setTime:(NSDate *)time {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    selectedTime=time;
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *timeString=[formatter stringFromDate:selectedTime];
    [self.selectTimeButton setTitle:timeString
                           forState:UIControlStateNormal];
}

//为虚拟键盘设置关闭按钮
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
    else if ([self.moneyTextField isFirstResponder])
        [self.moneyTextField resignFirstResponder];
}
@end
