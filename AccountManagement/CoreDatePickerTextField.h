//
//  CoreDatePickerTextField.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/8.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoManager.h"

#define CoreDataPickerTextFieldDebug 1

@class CoreDatePickerTextField;

@protocol CoreDataPickerTextFiledDelegate <NSObject>

-(void)selectedObjectID:(NSManagedObjectID *)objectID changedForPickerTextField:(CoreDatePickerTextField *)pickerTextFiled;

@optional
-(void)selectedObjectClearedForPickerTextField:(CoreDatePickerTextField *)pickerTextField;

@end

@interface CoreDatePickerTextField : UITextField <UIKeyInput,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,weak) id<CoreDataPickerTextFiledDelegate> pickerDelegate;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSArray *pickerData;
@property (nonatomic,strong) UIToolbar *toolBar;
@property (nonatomic) BOOL showToolBar;
@property (nonatomic,strong) NSManagedObjectID *selectedObjectID;

@end
