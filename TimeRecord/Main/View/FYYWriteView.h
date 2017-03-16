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

@interface FYYWriteView : UIScrollView <
    UITextViewDelegate,
    FYYAccessoryViewDelegate
>

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

/**
 编辑文本样式按钮
 */
@property (nonatomic, strong) UIButton *editStyleButton;

/**
 键盘工具栏
 */
@property (nonatomic, strong) FYYAccessoryView *accessoryView;

/**
 设置背景（稿纸）

 @param image 背景图片
 */
- (void)fyy_setWriteBackgroundImage:(NSString *)image;

@end
