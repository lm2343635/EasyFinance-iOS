//
//  SelectorView.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/8.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "SelectorView.h"
#import "Util.h"

@implementation SelectorView {
    //选择器视图高度
    CGFloat seletorHeight;
    //当前选择器是否被使用，选择器被使用时不能被另外一个按钮调用，除非点击done关闭选择器
    BOOL isUsing;
    //选择器类型
    int selectorType;
    //定义回调函数
    Callback doneButtonDidClicked;
}

-(void)initWithSelectorData:(NSArray *)selectorData
       andIconAttributeName:(NSString *)iconAttributeName
   andIconDataAttributeName:(NSString *)iconDataAttributeName
       andNameAttributeName:(NSString *)nameAttributeName
               withCallback:(Callback)callback {
    if(DEBUG==1&&PickerSelectorDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //选择器正在被其他按钮使用时不能被当前按钮调用
    if ([self isSelecotrEnable:selectorData]) {
        //设置选择器类型
        selectorType=SelectorTypeHasAnIcon;
        doneButtonDidClicked=callback;
        //设置初始化值
        self.selectorData=selectorData;
        self.iconAttributeName=iconAttributeName;
        self.iconDataAttributeName=iconDataAttributeName;
        self.nameAttributeName=nameAttributeName;
        [self loadPicker];
    }
}

-(void)initWithSelectorData:(NSArray *)selectorData
       andNameAttributeName:(NSString *)nameAttributeName
               withCallback:(Callback)callback {
    if(DEBUG==1&&PickerSelectorDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //选择器正在被其他按钮使用时不能被当前按钮调用
    if ([self isSelecotrEnable:selectorData]) {
        //设置选择器类型
        selectorType=SelectorTypeOnlyText;
        //设置回调函数
        doneButtonDidClicked=callback;
        self.selectorData=selectorData;
        self.nameAttributeName=nameAttributeName;
        [self loadPicker];
    }
}

//检查当前选择器是否可用
-(BOOL)isSelecotrEnable:(NSArray *)selectorData {
    if(DEBUG==1&&PickerSelectorDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //选择器正在被其他按钮使用时不能被当前按钮调用
    if(isUsing) {
        if(DEBUG && PickerSelectorDebug ) {
            NSLog(@"Selector is using by other button.");
        }
        [Util showAlert:SelectorBeUsingTip];
        return NO;
    }else if(selectorData.count==0) {//选择器数据是否为空
        if(DEBUG==1&&PickerSelectorDebug==1)
            NSLog(@"Selector has no data.");
        [Util showAlert:SelectorDataNullTip];
        return NO;
    }
    //初始化操作
    //当前按钮占用选择器
    isUsing=YES;
    //设置选择器高度
    seletorHeight=self.frame.size.height;
    if(DEBUG && PickerSelectorDebug ) {
        NSLog(@"Selector height is %f px.", seletorHeight);
    }
    return YES;
}

//完成初始化之后调用该方法，加载picker
-(void)loadPicker {
    if(DEBUG==1&&PickerSelectorDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //得到selectorView下的pickerView和doneButton
    self.pickerView=(UIPickerView *)[self viewWithTag:1];
    self.doneButton=(UIButton *)[self viewWithTag:2];
    //设置选择器数据源和代理为self
    self.pickerView.dataSource=self;
    self.pickerView.delegate=self;
    //设置按钮点击事件
    [self.doneButton addTarget:self
                        action:@selector(doneButtonClick)
              forControlEvents:UIControlEventTouchUpInside];
    //doneButton设为可用
    self.doneButton.enabled=YES;
    //初始化完成，显示选择器
    [self showSelector];
}

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if(DEBUG==1&&PickerSelectorDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(DEBUG==1&&PickerSelectorDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //加入一个第0行的提示
    return self.selectorData.count+1;
}

//加载定制的pickerView界面
-(UIView *)pickerView:(UIPickerView *)pickerView
           viewForRow:(NSInteger)row
         forComponent:(NSInteger)component
          reusingView:(UIView *)view {
    if(DEBUG==1&&PickerSelectorDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if(row==0) {
        //第0行给予提示，而非选择器
        UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        nameLabel.text=ZeroRowTip;
        view=nameLabel;
    }else{
        //得到该行要显示的数据对象
        NSObject *object=[self.selectorData objectAtIndex:row-1];
        //加载只显示文字的pickerView界面
        if(selectorType==SelectorTypeOnlyText) {
            UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
            nameLabel.textAlignment=NSTextAlignmentCenter;
            nameLabel.text=[object valueForKey:self.nameAttributeName];
            view=nameLabel;
        }else if (selectorType==SelectorTypeHasAnIcon) {
            //图标View
            UIImageView *iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(112, 0, 32, 32)];
            //图片数据
            NSData *data=[[object valueForKey:self.iconAttributeName] valueForKey:self.iconDataAttributeName];
            iconImageView.image=[UIImage imageWithData:data];
            //文字View
            UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(156, 0, 264, 32)];
            nameLabel.text=[object valueForKey:self.nameAttributeName];
            //添加到itemView中
            UIView *itemView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
            [itemView addSubview:iconImageView];
            [itemView addSubview:nameLabel];
            view=itemView;
        }
    }
    return view;
}

#pragma mark - UIPickerViewDelegate
//设置高度
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if(DEBUG==1&&PickerSelectorDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    return UIPickerViewLineHeight;
}

#pragma mark - Action
//显示选择器
-(void)showSelector {
    if(DEBUG && PickerSelectorDebug) {
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    }
    CGPoint center=self.center;
    if(DEBUG && PickerSelectorDebug) {
        NSLog(@"Selector start from (%f,%f)",center.x,center.y);
    }
    //[UIView animateWithDuration:AnimationDurationTime animations:^{
        self.center=CGPointMake(center.x, center.y-seletorHeight);
        if(DEBUG && PickerSelectorDebug) {
            NSLog(@"Selector end with (%f,%f)",self.center.x,self.center.y);
        }
    //}];
}

//隐藏选择器
-(void)hideSelector {
    if(DEBUG && PickerSelectorDebug) {
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    }
    CGPoint center=self.center;
    if(DEBUG && PickerSelectorDebug) {
        NSLog(@"Selector start from (%f,%f)",center.x,center.y);
    }
    [UIView animateWithDuration:AnimationDurationTime animations:^{
        self.center=CGPointMake(center.x, center.y+seletorHeight);
        if(DEBUG && PickerSelectorDebug) {
            NSLog(@"Selector end with (%f,%f)",self.center.x,self.center.y);
        }
    }];
}

//done按钮点击事件
-(void)doneButtonClick {
    if(DEBUG==1&&PickerSelectorDebug==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    //选中的行数
    NSInteger selectedRow=[self.pickerView selectedRowInComponent:0];
    if(selectedRow==0) {
        [Util showAlert:@"Please select an item before click the Done button."];
    }else{
        [self hideSelector];
        //第0行是提示，非0行才是正常数据
        NSObject *object=[self.selectorData objectAtIndex:selectedRow-1];
        //doneButton设为不可用
        self.doneButton.enabled=NO;
        //当前按钮释放选择器
        isUsing=NO;
        if(doneButtonDidClicked)
            doneButtonDidClicked(object);
    }
}
@end
