//
//  AddEarnController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/1/14.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "AddEarnViewController.h"

@interface AddEarnViewController ()

@end

@implementation AddEarnViewController

#pragma mark - Action
- (IBAction)saveEarnRecord:(id)sender {
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //验证合法才能提交
    if([self recordSubmitValidate]) {
        NSNumber *money=[NSNumber numberWithDouble:[self.moneyTextFeild.text doubleValue]];
        NSString *remark=self.remarkTextView.text;
        AccountBook *usingAccountBook=self.loginedUser.usingAccountBook;
        Photo *photo=nil;
        //如果用户拍过照就要新建Photo对象
        if(self.photoImage!=nil) {
            NSManagedObjectID *pid=[self.dao.photoDao saveWithData:UIImageJPEGRepresentation(self.photoImage, 1.0)
                                                     inAccountBook:usingAccountBook];
            if(DEBUG==1)
                NSLog(@"Create photo(pid=%@) in accountBook %@",pid,usingAccountBook.abname);
            photo=(Photo *)[self.dao getObjectById:pid];
        }
        NSManagedObjectID *rid=[self.dao.recordDao saveWithMoney:money
                                                       andRemark:remark
                                                         andTime:self.selectedTime
                                               andClassification:self.selectedClassification
                                                      andAccount:self.selectedAccount
                                                         andShop:self.selectedShop
                                                        andPhoto:photo
                                                   inAccountBook:usingAccountBook];
        if(DEBUG==1)
            NSLog(@"Create record(rid=%@) in accountBook %@",rid,usingAccountBook.abname);
        if(rid)
            [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
