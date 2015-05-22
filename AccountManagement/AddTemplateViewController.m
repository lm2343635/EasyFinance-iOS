//
//  AddTemplateViewController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/8.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AddTemplateViewController.h"
#import "DaoManager.h"
#import "Util.h"

@interface AddTemplateViewController ()

@end

@implementation AddTemplateViewController {
    DaoManager *dao;
    User *loginedUser;
    NSArray *classifications;
    NSArray *accounts;
    NSArray *shops;
    //被选择的对象
    Classification *selectedClassification;
    Account *selectedAccount;
    Shop *selectedShop;
}

- (void)viewDidLoad {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [super viewDidLoad];
    dao=[[DaoManager alloc] init];
    loginedUser=[dao.userDao getLoginedUser];
    //加载分类，账户和商家
    classifications=[loginedUser.usingAccountBook.classifications allObjects];
    accounts=[loginedUser.usingAccountBook.accounts allObjects];
    shops=[loginedUser.usingAccountBook.shops allObjects];
    selectedClassification=nil;
    selectedAccount=nil;
    selectedShop=nil;
}

#pragma mark - Action
//点击屏幕空白区域关闭当前激活的虚拟键盘
- (IBAction)dismissKeyboard:(id)sender {
    NSArray *subViews=[self.view subviews];
    for(id input in subViews){
        if([input isKindOfClass:[UITextField class]]){
            UITextField *this=input;
            if([this isFirstResponder])
                [this resignFirstResponder];
        }
    }
}

-(IBAction)finishEdit:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [sender resignFirstResponder];
}

//选择分类
- (IBAction)selectClassification:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self.selectorView initWithSelectorData:classifications
                       andIconAttributeName:@"cicon"
                   andIconDataAttributeName:@"idata"
                       andNameAttributeName:@"cname"
                               withCallback:^(NSObject *object) {
                                   //根据回调对象设置Button和ImageView
                                   selectedClassification=(Classification *)object;
                                   UIImage *image=[UIImage imageWithData:selectedClassification.cicon.idata];
                                   self.selectClassificationIconImageView.image=image;
                                   [self.selectClassificationButton setTitle:selectedClassification.cname
                                                                    forState:UIControlStateNormal];
                               }];
}

//选择账户
- (IBAction)selectAccount:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self.selectorView initWithSelectorData:accounts
                       andIconAttributeName:@"aicon"
                   andIconDataAttributeName:@"idata"
                       andNameAttributeName:@"aname"
                               withCallback:^(NSObject *object) {
                                   selectedAccount=(Account *)object;
                                   UIImage *image=[UIImage imageWithData:selectedAccount.aicon.idata];
                                   self.selectAccountIconImageView.image=image;
                                   [self.selectAccountButton setTitle:selectedAccount.aname
                                                             forState:UIControlStateNormal];
                               }];
}

//选择商家
- (IBAction)selectShop:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self.selectorView initWithSelectorData:shops
                       andIconAttributeName:@"sicon"
                   andIconDataAttributeName:@"idata"
                       andNameAttributeName:@"sname"
                               withCallback:^(NSObject *object) {
                                   selectedShop=(Shop *)object;
                                   UIImage *image=[UIImage imageWithData:selectedShop.sicon.idata];
                                   self.selectShopIconImageView.image=image;
                                   [self.selectShopButton setTitle:selectedShop.sname
                                                          forState:UIControlStateNormal];
                               }];
}


//保存模板
- (IBAction)saveTemplate:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSString *templateName=self.templateNameTextField.text;
    //选择不完整，不让提交
    if([templateName isEqualToString:@""]||
       selectedClassification==nil||
       selectedAccount==nil||
       selectedShop==nil) {
        if(DEBUG==1)
            NSLog(@"Cannot save template because object index has null item.");
        [Util showAlert:@"Please input template name, then choose a classification, an account and a shop before you save template."];
    }else{
        NSManagedObjectID *tpid=[dao.templateDao saveWithAccountBook:loginedUser.usingAccountBook
                                                           andTpname:templateName
                                                   andClassification:selectedClassification
                                                          andAccount:selectedAccount
                                                             andShop:selectedShop];
        if(DEBUG==1)
            NSLog(@"Create template(tpid=%@) in accountBook %@",tpid,loginedUser.usingAccountBook.abname);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
