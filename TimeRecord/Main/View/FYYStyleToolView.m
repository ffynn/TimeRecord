//
//  FYYStyleToolView.m
//  TimeRecord
//
//  Created by FLYang on 2017/3/17.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import "FYYStyleToolView.h"

static const NSInteger ColorButtonTag = 100;
static const NSInteger PaperButtonTag = 110;
static const CGFloat ToolViewHeight = 110;

@interface FYYStyleToolView () {
    NSString *_chooseColor; //  选择的颜色
    NSArray  *_colorArr;    //  全部的颜色
    NSArray  *_paperArr;    //  全部的背景
}

@end

@implementation FYYStyleToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.0f];
        [self addPanGestureRecognizer];
        _colorArr = @[@"#411616", @"#222222", @"#FFFFFF", @"#B11212", @"#105F9C", @"#CFB136"];
        [self setViewUI];
    }
    return self;
}

#pragma mark - 恢复默认
- (void)fyy_restoreTheDefault {
    self.frame = CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, ToolViewHeight);
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
    CGFloat translationY = y < -80 ? -80 : y;
    
    CGRect formerFrame = self.frame;
    formerFrame = CGRectMake(0, SCREEN_HEIGHT - 30 + translationY, SCREEN_WIDTH, ToolViewHeight);
    self.frame = formerFrame;
    
    if (translationY <= -60) {
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
    
    [self.backView addSubview:self.colorStyle];
    [_colorStyle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(_backView.mas_left).with.offset(20);
        make.centerY.equalTo(_backView);
    }];
    
    [self creatTextColorButton];
    
//    [self.backView addSubview:self.paperStyle];
//    [_paperStyle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(40, 40));
//        make.left.equalTo(_colorStyle.mas_right).with.offset(10);
//        make.centerY.equalTo(_backView.mas_centerY).with.offset(2);
//    }];
}

#pragma mark - 打开编辑工具栏
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
        defaultFrame = CGRectMake(0, SCREEN_HEIGHT - ToolViewHeight, SCREEN_WIDTH, ToolViewHeight);
    
    } else if (button.selected == YES) {
        button.selected = NO;
        defaultFrame = CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, ToolViewHeight);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = defaultFrame;
    }];
}

#pragma mark - 工具栏的背景
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

#pragma mark - 更换背景稿纸
- (UIButton *)paperStyle {
    if (!_paperStyle) {
        _paperStyle = [[UIButton alloc] init];
        [_paperStyle setImage:[UIImage imageNamed:@"icon_style_paper"] forState:(UIControlStateNormal)];
        [_paperStyle setImage:[UIImage imageNamed:@"icon_style_paper"] forState:(UIControlStateHighlighted)];
        [_paperStyle setImage:[UIImage imageNamed:@"icon_style_edit_back"] forState:(UIControlStateSelected)];
        [_paperStyle addTarget:self action:@selector(paperStyleClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _paperStyle.selected = NO;
    }
    return _paperStyle;
}

- (void)paperStyleClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        
    } else if (button.selected == YES) {
        button.selected = NO;
    }
    
    if ([self.tool_delegate respondsToSelector:@selector(fyy_changeWriteTextPaper:)]) {
        [self.tool_delegate fyy_changeWriteTextPaper:@"background_paper_6"];
    }
}

#pragma mark - 更换文本颜色
- (UIButton *)colorStyle {
    if (!_colorStyle) {
        _colorStyle = [[UIButton alloc] init];
        [_colorStyle setImage:[UIImage imageNamed:@"icon_style_edit"] forState:(UIControlStateNormal)];
        [_colorStyle setImage:[UIImage imageNamed:@"icon_style_edit"] forState:(UIControlStateHighlighted)];
        [_colorStyle setImage:[UIImage imageNamed:@"icon_style_edit_back"] forState:(UIControlStateSelected)];
        [_colorStyle addTarget:self action:@selector(colorStyleClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _colorStyle.selected = NO;
    }
    return _colorStyle;
}

- (void)colorStyleClick:(UIButton *)button {
    [self changeColorButtonFrame:button.selected];
    [self changePaperButtonFrame:button.selected];
    
    if (button.selected == NO) {
        button.selected = YES;
        self.paperStyle.hidden = YES;
        
    } else if (button.selected == YES) {
        button.selected = NO;
        self.paperStyle.hidden = NO;
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
            make.left.equalTo(_colorStyle.mas_right).with.offset(20 + margin * (index - 1));
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

- (void)changePaperButtonFrame:(BOOL)hidden {
    CGFloat margin = hidden == YES ? 0 : (SCREEN_WIDTH - 80)/self.paperButtonMarr.count;
    
    NSInteger index = 0;
    for (UIButton *paperBtn in self.paperButtonMarr) {
        ++ index;
        if (hidden == NO) {
            paperBtn.hidden = hidden;
        }
        [paperBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_colorStyle.mas_right).with.offset(20 + margin * (index - 1));
        }];
        
        [UIView animateWithDuration:0.5
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.0
                            options:(UIViewAnimationOptionCurveEaseOut) animations:^{
                                paperBtn.alpha = hidden == YES ? 0.0f : 1.0f;
                                [self layoutIfNeeded];
                            }
                         completion:^(BOOL finished) {
                             if (hidden == YES) {
                                 paperBtn.hidden = YES;
                             }
                         }];
    }
}

- (void)creatTextColorButton {
    //  颜色
    for (NSInteger idx = 0; idx < _colorArr.count; ++ idx) {
        UIButton *colorBtn = [[UIButton alloc] init];
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
            make.left.equalTo(_colorStyle.mas_right).with.offset(20);
            make.bottom.equalTo(_backView.mas_centerY).with.offset(-4);
        }];
        
        [self.colorButtonMarr addObject:colorBtn];
    }
    
    //  稿纸
    for (NSInteger jdx = 0; jdx < _colorArr.count; ++ jdx) {
        UIButton *paperBtn = [[UIButton alloc] init];
        [paperBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"background_paper_%zi", jdx + 1]] forState:(UIControlStateNormal)];
        paperBtn.layer.cornerRadius = 15;
        paperBtn.layer.masksToBounds = YES;
        paperBtn.layer.borderWidth = 1.0f;
        paperBtn.layer.borderColor = [UIColor colorWithHexString:@"#CECECE" alpha:1.0f].CGColor;
        paperBtn.tag = PaperButtonTag + jdx;
        [paperBtn addTarget:self action:@selector(changePaper:) forControlEvents:(UIControlEventTouchUpInside)];
        paperBtn.hidden = YES;
        
        [self addSubview:paperBtn];
        [paperBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.equalTo(_colorStyle.mas_right).with.offset(20);
            make.top.equalTo(_backView.mas_centerY).with.offset(4);
        }];
        
        [self.paperButtonMarr addObject:paperBtn];
    }
}

- (void)changeColor:(UIButton *)button {
    NSInteger index = button.tag - ColorButtonTag;
    NSString *colorStr = _colorArr[index];
    
    if ([self.tool_delegate respondsToSelector:@selector(fyy_changeWriteTextColor:)]) {
        [self.tool_delegate fyy_changeWriteTextColor:colorStr];
    }
}

- (void)changePaper:(UIButton *)button {
    NSInteger index = button.tag - PaperButtonTag;
    if ([self.tool_delegate respondsToSelector:@selector(fyy_changeWriteTextColor:)]) {
        [self.tool_delegate fyy_changeWriteTextPaper:[NSString stringWithFormat:@"background_paper_%zi", index + 1]];
    }
}

#pragma mark - 
- (NSMutableArray *)colorButtonMarr {
    if (!_colorButtonMarr) {
        _colorButtonMarr = [NSMutableArray array];
    }
    return _colorButtonMarr;
}

- (NSMutableArray *)paperButtonMarr {
    if (!_paperButtonMarr) {
        _paperButtonMarr = [NSMutableArray array];
    }
    return _paperButtonMarr;
}

@end
