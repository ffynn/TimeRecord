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
- (void)fyy_changeWriteTextPaper:(NSString *)paper;

@end

@interface FYYStyleToolView : UIView
//<
//    UICollectionViewDelegate,
//    UICollectionViewDataSource
//>

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
 编辑颜色按钮
 */
@property (nonatomic, strong) UIButton *colorStyle;

/**
 稿纸背景按钮
 */
@property (nonatomic, strong) UIButton *paperStyle;

/**
 工具栏恢复默认
 */
- (void)fyy_restoreTheDefault;

@property (nonatomic, strong) NSMutableArray *colorButtonMarr;
@property (nonatomic, strong) NSMutableArray *paperButtonMarr;

@end
