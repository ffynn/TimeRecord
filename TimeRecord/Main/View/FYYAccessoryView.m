//
//  FYYAccessoryView.m
//  TimeRecord
//
//  Created by FLYang on 2017/3/16.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import "FYYAccessoryView.h"

@implementation FYYAccessoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setViewUI];
    }
    return self;
}

- (void)setViewUI {
    [self addSubview:self.insertImage];
    [_insertImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self).with.offset(0);
        make.width.mas_equalTo(@120);
    }];
    
    [self addSubview:self.saveDraft];
    [_saveDraft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self).with.offset(0);
        make.left.equalTo(_insertImage.mas_right).with.offset(0);
        make.width.mas_equalTo(@120);
    }];
    
    [self addSubview:self.closeKeybord];
    [_closeKeybord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self).with.offset(0);
        make.width.mas_equalTo(@44);
    }];
}

- (UIButton *)insertImage {
    if (!_insertImage) {
        _insertImage = [[UIButton alloc] init];
        [_insertImage setImage:[UIImage imageNamed:@"icon_insertImage"] forState:(UIControlStateNormal)];
        [_insertImage addTarget:self action:@selector(insertImageClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _insertImage;
}

- (UIButton *)saveDraft {
    if (!_saveDraft) {
        _saveDraft = [[UIButton alloc] init];
        [_saveDraft setImage:[UIImage imageNamed:@"icon_saveDraft"] forState:(UIControlStateNormal)];
        [_saveDraft addTarget:self action:@selector(saveDraftClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _saveDraft;
}

- (UIButton *)closeKeybord {
    if (!_closeKeybord) {
        _closeKeybord = [[UIButton alloc] init];
        [_closeKeybord setImage:[UIImage imageNamed:@"icon_closeKeybord"] forState:(UIControlStateNormal)];
        [_closeKeybord addTarget:self action:@selector(closeKeybordClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeKeybord;
}

- (void)insertImageClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(fyy_writeInputBoxInsertImage)]) {
        [self.delegate fyy_writeInputBoxInsertImage];
    }
}

- (void)saveDraftClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(fyy_writeInputBoxSaveDraft)]) {
        [self.delegate fyy_writeInputBoxSaveDraft];
    }
}

- (void)closeKeybordClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(fyy_writeInputBoxResignFirstResponder)]) {
        [self.delegate fyy_writeInputBoxResignFirstResponder];
    }
}

@end
