//
//  FYYPromptView.h
//  TimeRecord
//
//  Created by FLYang on 2017/3/16.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYYMacro.h"

typedef NS_ENUM(NSInteger, PromptStatus) {
    PromptStatusWarning = 1,    //  警告
    PromptStatusSucceed,        //  成功
    PromptStatusError,          //  错误
};

@interface FYYPromptView : UIView

/**
 提示文本框
 */
@property (nonatomic, strong) UILabel *textLabel;

/**
 显示提示语

 @param text 提示文字
 */
+ (void)showWithText:(NSString *)text status:(PromptStatus)status;

@end
