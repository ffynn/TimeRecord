//
//  FYYColorCollectionViewCell.m
//  TimeRecord
//
//  Created by FLYang on 2017/4/5.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import "FYYColorCollectionViewCell.h"

@implementation FYYColorCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self fyy_setCellViewUI];
    }
    return self;
}

- (void)fyy_setTextColor:(NSString *)textColor paperImage:(NSString *)paperImage {
    self.textButton.backgroundColor = [UIColor colorWithHexString:textColor alpha:1.0f];
    [self.paperButton setImage:[UIImage imageNamed:paperImage] forState:(UIControlStateNormal)];
}

- (void)fyy_setCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.paperButton];
    [_paperButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.centerX.centerY.equalTo(self);
    }];
    
    [self addSubview:self.textButton];
    [_textButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.centerX.equalTo(_paperButton);
    }];
}

- (UIButton *)paperButton {
    if (!_paperButton) {
        _paperButton = [[UIButton alloc] init];
        _paperButton.userInteractionEnabled = NO;
        _paperButton.layer.cornerRadius = 5;
        _paperButton.layer.masksToBounds = YES;
        _paperButton.layer.borderWidth = 0.5f;
        _paperButton.layer.borderColor = [UIColor colorWithHexString:@"#CECECE" alpha:1.0f].CGColor;
    }
    return _paperButton;
}

- (UIButton *)textButton {
    if (!_textButton) {
        _textButton = [[UIButton alloc] init];
        _textButton.userInteractionEnabled = NO;
        _textButton.layer.cornerRadius = 30/2;
        _textButton.layer.masksToBounds = YES;
    }
    return _textButton;
}

@end
