//
//  FYYStyleToolView.m
//  TimeRecord
//
//  Created by FLYang on 2017/3/17.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import "FYYStyleToolView.h"

static const NSInteger ColorButtonTag = 100;

@interface FYYStyleToolView () {
    NSString *_chooseColor; //  选择的颜色
    NSArray  *_colorArr;    //  全部的颜色
}

@end

@implementation FYYStyleToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.0f];
        [self addPanGestureRecognizer];
        _colorArr = @[@"#411616", @"#222222", @"#666666", @"#B11212", @"#105F9C", @"#CFB136"];
        [self setViewUI];
    }
    return self;
}

#pragma mark - 恢复默认
- (void)fyy_restoreTheDefault {
    self.frame = CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 90);
    self.openButton.selected = NO;
}

#pragma mark - 添加拖移手势
- (void)addPanGestureRecognizer {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(openStyleTool:)];
    [self addGestureRecognizer:pan];
}

- (void)openStyleTool:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self];
    
    if (translation.y < 0) {
        [self changeViewFrame:translation.y];
    }
}

- (void)changeViewFrame:(CGFloat)y {
    CGFloat translationY = y < -60 ? -60 : y;
    
    CGRect formerFrame = self.frame;
    formerFrame = CGRectMake(0, SCREEN_HEIGHT - 30 + translationY, SCREEN_WIDTH, 90);
    self.frame = formerFrame;
    
    if (translationY <= -40) {
        self.openButton.selected = YES;
    }
}

#pragma mark - 添加视图控件
- (void)setViewUI {
    [self addSubview:self.openButton];
    [_openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(self).with.offset(0);
        make.top.equalTo(_openButton.mas_bottom).with.offset(-1);
    }];
    
    [self.backView addSubview:self.editStyle];
    [_editStyle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(_backView.mas_left).with.offset(20);
        make.centerY.equalTo(_backView);
    }];
    
    [self creatTextColorButton];
}

- (UIButton *)openButton {
    if (!_openButton) {
        _openButton = [[UIButton alloc] init];
        [_openButton setImage:[UIImage imageNamed:@"icon_open_tool"] forState:(UIControlStateNormal)];
        [_openButton setImage:[UIImage imageNamed:@"icon_close_tool"] forState:(UIControlStateSelected)];
        [_openButton setImage:[UIImage imageNamed:@"icon_open_tool"] forState:(UIControlStateHighlighted)];
        [_openButton addTarget:self action:@selector(openButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _openButton.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.0f];
    }
    return _openButton;
}

- (void)openButtonClick:(UIButton *)button {
    CGRect defaultFrame = self.frame;
    
    if (button.selected == NO) {
        button.selected = YES;
        defaultFrame = CGRectMake(0, SCREEN_HEIGHT - 90, SCREEN_WIDTH, 90);
    
    } else if (button.selected == YES) {
        button.selected = NO;
        defaultFrame = CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 90);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = defaultFrame;
    }];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIButton *)editStyle {
    if (!_editStyle) {
        _editStyle = [[UIButton alloc] init];
        [_editStyle setImage:[UIImage imageNamed:@"icon_style_edit"] forState:(UIControlStateNormal)];
        [_editStyle setImage:[UIImage imageNamed:@"icon_style_edit"] forState:(UIControlStateHighlighted)];
        [_editStyle setImage:[UIImage imageNamed:@"icon_style_edit_back"] forState:(UIControlStateSelected)];
        [_editStyle addTarget:self action:@selector(editStyleClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _editStyle.selected = NO;
    }
    return _editStyle;
}

- (void)editStyleClick:(UIButton *)button {
    [self changeColorButtonFrame:button.selected];
    
    if (button.selected == NO) {
        button.selected = YES;
    } else if (button.selected == YES) {
        button.selected = NO;
    }
}

- (void)changeColorButtonFrame:(BOOL)hidden {
    CGFloat margin = hidden == YES ? 0 : (SCREEN_WIDTH - 80)/self.colorButtonMarr.count;
    
    NSInteger index = 0;
    
    for (UIButton *colorBtn in self.colorButtonMarr) {
        ++ index;
        if (hidden == NO) {
            colorBtn.hidden = hidden;
        }
        [colorBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_editStyle.mas_right).with.offset(20 + margin * (index - 1));
            make.centerY.equalTo(_editStyle.mas_centerY).with.offset(0);
        }];
        
        [UIView animateWithDuration:0.5
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.0
                            options:(UIViewAnimationOptionCurveEaseOut) animations:^{
                                colorBtn.alpha = hidden == YES ? 0.0f : 1.0f;
                                [self layoutIfNeeded];
                            }
                         completion:^(BOOL finished) {
                             if (hidden == YES) {
                                 colorBtn.hidden = YES;
                             }
                         }];
    }
}

- (void)creatTextColorButton {
    for (NSInteger idx = 0; idx < _colorArr.count; ++ idx) {
        UIButton *colorBtn = [[UIButton alloc] initWithFrame:CGRectMake(40 * idx, 0, 30, 30)];
        colorBtn.backgroundColor = [UIColor colorWithHexString:_colorArr[idx] alpha:1.0f];
        colorBtn.layer.cornerRadius = 15;
        colorBtn.layer.masksToBounds = YES;
        colorBtn.layer.borderWidth = 3.0f;
        colorBtn.layer.borderColor = [UIColor colorWithHexString:@"#CECECE" alpha:1.0f].CGColor;
        colorBtn.tag = ColorButtonTag + idx;
        [colorBtn addTarget:self action:@selector(changeColor:) forControlEvents:(UIControlEventTouchUpInside)];
        colorBtn.hidden = YES;
        
        [self addSubview:colorBtn];
        [colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.equalTo(_editStyle.mas_right).with.offset(20);
            make.centerY.equalTo(_editStyle.mas_centerY).with.offset(2);
        }];
        
        [self.colorButtonMarr addObject:colorBtn];
    }
}

- (void)changeColor:(UIButton *)button {
    NSInteger index = button.tag - ColorButtonTag;
    NSString *colorStr = _colorArr[index];
    
    if ([self.tool_delegate respondsToSelector:@selector(fyy_changeWriteTextColor:)]) {
        [self.tool_delegate fyy_changeWriteTextColor:colorStr];
    }
}

#pragma mark - 
- (NSMutableArray *)colorButtonMarr {
    if (!_colorButtonMarr) {
        _colorButtonMarr = [NSMutableArray array];
    }
    return _colorButtonMarr;
}

@end
