//
//  SelectorView.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/8.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PickerSelectorDebug 0

//左侧带一张图片的选择器
#define SelectorTypeHasAnIcon 0
//纯文字的选择器
#define SelectorTypeOnlyText 1

//第0行的提示文字
#define ZeroRowTip @"    Please choose an item."
//选择器被其他按钮占用时，提示用户先完成当前按钮的选择
#define SelectorBeUsingTip @"Please finish what you are choosing now."
//选择器数据为空时，提示用户没有选择项
#define SelectorDataNullTip @"There is no data in this seletor."
//动画时间长度
#define AnimationDurationTime 0.3
//定义UIPickerView的行高度
#define UIPickerViewLineHeight 44.0

//定义回调函数数据类型
typedef void (^Callback)(NSObject *);

@interface SelectorView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

//数据属性
//待选数据
@property (strong, nonatomic) NSArray *selectorData;
//对象中图标属性的名称
@property (strong, nonatomic) NSString *iconAttributeName;
//对象中图标属性的数据属性的名称
@property (strong, nonatomic) NSString *iconDataAttributeName;
//对象中名称属性的名称
@property (strong, nonatomic) NSString *nameAttributeName;

//视图属性
//选取器视图
@property (strong, nonatomic) UIPickerView *pickerView;
//done按钮
@property (strong, nonatomic) UIButton *doneButton;

//带图片的选择器初始化方法
-(void)initWithSelectorData:(NSArray *)selectorData
       andIconAttributeName:(NSString *)iconAttributeName
   andIconDataAttributeName:(NSString *)iconDataAttributeName
       andNameAttributeName:(NSString *)nameAttributeName
               withCallback:(Callback)callback;

//纯文字的选择权初始化方法
-(void)initWithSelectorData:(NSArray *)selectorData
       andNameAttributeName:(NSString *)nameAttributeName
               withCallback:(Callback)callback;

//显示选择器
-(void)showSelector;
//隐藏选择器
-(void)hideSelector;

@end
