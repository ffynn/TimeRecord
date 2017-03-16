//
//  FYYPromptView.m
//  TimeRecord
//
//  Created by FLYang on 2017/3/16.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import "FYYPromptView.h"

static NSString *const PromptStatusWarningColor = @"#F39E6B";
static NSString *const PromptStatusSucceedColor = @"#6BF389";
static NSString *const PromptStatusErrorColor = @"#F36B6B";

@implementation FYYPromptView

+ (FYYPromptView *)sharedView {
    static dispatch_once_t once;
    static FYYPromptView *sharedView;
    sharedView = [[self alloc] initWithFrame:CGRectMake(0, -40, SCREEN_WIDTH, 40)];
    dispatch_once(&once, ^ { sharedView = [[self alloc] initWithFrame:CGRectMake(0, -40, SCREEN_WIDTH, 40)];});
    return sharedView;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(self);
        }];
    }
    return self;
}

+ (void)showWithText:(NSString *)text status:(PromptStatus)status {
    [self sharedView];
    [[self sharedView] showPromptWithText:text status:status];
}

- (void)showPromptWithText:(NSString *)text status:(PromptStatus)status {
    if (!self.superview) {
        NSEnumerator *toBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in toBackWindows) {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self];
                break;
            }
        }
    
        self.textLabel.text = text;
        switch (status) {
            case PromptStatusWarning:
                self.backgroundColor = [UIColor colorWithHexString:PromptStatusWarningColor];
                break;
            case PromptStatusSucceed:
                self.backgroundColor = [UIColor colorWithHexString:PromptStatusSucceedColor];
                break;
            case PromptStatusError:
                self.backgroundColor = [UIColor colorWithHexString:PromptStatusErrorColor];
                break;
        }
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
                             
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.3
                                                   delay:2
                                                 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                                              animations:^{
                                                  self.frame = CGRectMake(0, -40, SCREEN_WIDTH, 40);
                                              }
                                              completion:nil];
        }];
        
        [self setNeedsDisplay];
    }
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont boldSystemFontOfSize:14];
        _textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        }
    return _textLabel;
}

@end
