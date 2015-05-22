//
//  CoreDatePickerTextField.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/8.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "CoreDatePickerTextField.h"

@implementation CoreDatePickerTextField

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if(DEBUG==1&&CoreDataPickerTextFieldDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(DEBUG==1&&CoreDataPickerTextFieldDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return self.pickerData.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(DEBUG==1&&CoreDataPickerTextFieldDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return [self.pickerData objectAtIndex:row];
}

#pragma mark - UIPickerViewDelegate
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if(DEBUG==1&&CoreDataPickerTextFieldDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return 44.0f;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if(DEBUG==1&&CoreDataPickerTextFieldDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return 280.0f;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(DEBUG==1&&CoreDataPickerTextFieldDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSManagedObject *object=[self.pickerData objectAtIndex:row];
    [self.pickerDelegate selectedObjectID:object.objectID
                changedForPickerTextField:self];
}

#pragma mark - Interaction
-(void)done {
    if(DEBUG==1&&CoreDataPickerTextFieldDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self resignFirstResponder];
}

-(void)clear {
    if(DEBUG==1&&CoreDataPickerTextFieldDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self.pickerDelegate selectedObjectClearedForPickerTextField:self];
    [self resignFirstResponder];
}

#pragma mark - Data
-(void)fetch {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override the '%@' method to provide data to the picker.",NSStringFromSelector(_cmd)];
}

-(void)selectedDefaultRow {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override the '%@' method to set the default picker row.",NSStringFromSelector(_cmd)];
}

#pragma mark - View
-(UIView *)createInputView {
    if(DEBUG==1&&CoreDataPickerTextFieldDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    self.pickerView=[[UIPickerView alloc] initWithFrame:CGRectZero];
    self.pickerView.showsSelectionIndicator=YES;
    self.pickerView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    self.pickerView.dataSource=self;
    self.pickerView.delegate=self;
    return self.pickerView;
}

-(UIView *)createInputAccessoryView {
    if(DEBUG==1&&CoreDataPickerTextFieldDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    self.showToolBar=YES;
    if(!self.toolBar&&self.showToolBar) {
        self.toolBar=[[UIToolbar alloc] init];
        self.toolBar.barStyle=UIBarStyleDefault;
        self.toolBar.autoresizingMask=UIViewAutoresizingFlexibleHeight;
        [self.toolBar sizeToFit];
        CGRect frame=self.toolBar.frame;
        frame.size.height=44.0f;
        self.toolBar.frame=frame;
        UIBarButtonItem *clearButton=[[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(clear)];
        UIBarButtonItem *spacer=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:self
                                                                              action:nil];
        UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:nil];
        NSArray *array=[NSArray arrayWithObjects:clearButton,spacer,doneButton,nil];
        [self.toolBar setItems:array];
    }
    return self.toolBar;
}

-(id)initWithFrame:(CGRect)frame {
    if(DEBUG==1&&CoreDataPickerTextFieldDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if(self=[super initWithFrame:frame]) {
        self.inputView=[self createInputView];
        self.inputAccessoryView=[self createInputView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(DEBUG==1&&CoreDataPickerTextFieldDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if(self=[super initWithCoder:aDecoder]) {
        self.inputView=[self createInputView];
        self.inputAccessoryView=[self createInputView];
    }
    return self;
}

-(void)deviceDidRotate:(NSNotification *)notification {
    if(DEBUG==1&&CoreDataPickerTextFieldDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self.pickerView setNeedsLayout];
}
@end
