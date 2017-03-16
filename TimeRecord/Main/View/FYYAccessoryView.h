//
//  FYYAccessoryView.h
//  TimeRecord
//
//  Created by FLYang on 2017/3/16.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYYMacro.h"

@protocol FYYAccessoryViewDelegate <NSObject>

@optional
- (void)fyy_writeInputBoxResignFirstResponder;
- (void)fyy_writeInputBoxInsertImage;
- (void)fyy_writeInputBoxSaveDraft;

@end

@interface FYYAccessoryView : UIView

@property (nonatomic, weak) id <FYYAccessoryViewDelegate> delegate;

/**
 插入图片
 */
@property (nonatomic, strong) UIButton *insertImage;

/**
 保存草稿
 */
@property (nonatomic, strong) UIButton *saveDraft;

/**
 关闭键盘
 */
@property (nonatomic, strong) UIButton *closeKeybord;

/**
 开启键盘拓展功能

 @param open 开启
 */
- (void)setHiddenExtendingFunction:(BOOL)hidden;

@end
