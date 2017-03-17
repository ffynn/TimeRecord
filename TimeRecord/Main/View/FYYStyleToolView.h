//
//  FYYStyleToolView.h
//  TimeRecord
//
//  Created by FLYang on 2017/3/17.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYYMacro.h"

@protocol FYYStyleToolViewDelegate <NSObject>

@optional
- (void)fyy_changeWriteTextColor:(NSString *)color;

@end

@interface FYYStyleToolView : UIView

@property (nonatomic, weak) id <FYYStyleToolViewDelegate> tool_delegate;

/**
 打开工具抽屉的按钮
 */
@property (nonatomic, strong) UIButton *openButton;

/**
 背景
 */
@property (nonatomic, strong) UIView *backView;

/**
 编辑样式
 */
@property (nonatomic, strong) UIButton *editStyle;

/**
 工具栏恢复默认
 */
- (void)fyy_restoreTheDefault;

@property (nonatomic, strong) NSMutableArray *colorButtonMarr;

@end
