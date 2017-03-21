//
//  FYYWriteView.h
//  TimeRecord
//
//  Created by FLYang on 2017/3/15.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYYMacro.h"
#import "FYYAccessoryView.h"

@protocol FYYWriteDelegate <NSObject>

@optional
- (void)fyy_beginWrite;
- (void)fyy_endWrite;

@end

@interface FYYWriteView : UIScrollView <
    UITextViewDelegate,
    FYYAccessoryViewDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate
>

@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, weak) id <FYYWriteDelegate> write_delegate;

/**
 标题输入框
 */
@property (nonatomic, strong) UITextView *titleInputBox;
@property (nonatomic, strong) UILabel *titlePlaceholder;
@property (nonatomic, strong) UIImageView *titleLeftView;
@property (nonatomic, strong) UIImageView *titleRightView;

/**
 正文内容输入框
 */
@property (nonatomic, strong) UITextView *contentInputBox;
@property (nonatomic, strong) UILabel *contentPlaceholder;

/**
 底部编辑文本样式按钮
 */
@property (nonatomic, strong) UIButton *editStyleButton;

/**
 键盘工具栏
 */
@property (nonatomic, strong) FYYAccessoryView *accessoryView;

/**
 显示时间戳
 */
@property (nonatomic, strong) UILabel *timeStamp;

/**
 是否显示时间戳

 @param show 是／否
 */
- (void)fyy_showTimeStamp:(BOOL)show;

/**
 改变字体颜色

 @param color 颜色
 */
- (void)fyy_setWriteTextColor:(NSString *)color;

/**
 改变稿纸的背景

 @param paper 稿纸名称
 */
- (void)fyy_setWriteViewPaper:(NSString *)paper;

@end
