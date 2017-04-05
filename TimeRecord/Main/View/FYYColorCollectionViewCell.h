//
//  FYYColorCollectionViewCell.h
//  TimeRecord
//
//  Created by FLYang on 2017/4/5.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYYMacro.h"

@interface FYYColorCollectionViewCell : UICollectionViewCell

/**
 稿纸背景颜色
 */
@property (nonatomic, strong) UIButton *paperButton;

/**
 文字颜色
 */
@property (nonatomic, strong) UIButton *textButton;

/**
 设置背景的颜色

 @param textColor 文字颜色
 @param paperImage 稿纸颜色
 */
- (void)fyy_setTextColor:(NSString *)textColor paperImage:(NSString *)paperImage;

@end
