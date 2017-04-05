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

@interface FYYStyleToolView : UIView <
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@property (nonatomic, weak) id <FYYStyleToolViewDelegate> tool_delegate;

/**
 打开工具抽屉的按钮
 */
@property (nonatomic, strong) UIButton *openButton;

/**
 颜色工具
 */
@property (nonatomic, strong) UICollectionView *styleCollectionView;

/**
 提示语
 */
@property (nonatomic, strong) UILabel *tipLabel;

/**
 工具栏恢复默认
 */
- (void)fyy_restoreTheDefault;

@end
