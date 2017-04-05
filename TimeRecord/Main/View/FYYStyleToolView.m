//
//  FYYStyleToolView.m
//  TimeRecord
//
//  Created by FLYang on 2017/3/17.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import "FYYStyleToolView.h"
#import "FYYColorCollectionViewCell.h"

static CGFloat   const ToolViewHeight = 90;
static NSString *const ColorCellId = @"FYYColorCollectionViewCellId";

@interface FYYStyleToolView () {
    NSArray  *_colorArr;    //  全部的颜色
}

@end

@implementation FYYStyleToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.0f];
        
        _colorArr = @[@"#411616", @"#08192D", @"#FFFFFF", @"#FCFAF2", @"#58B2DC", @"#CFB136"];
        
        [self setViewUI];
    }
    return self;
}

#pragma mark - 恢复默认
- (void)fyy_restoreTheDefault {
    self.frame = CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, ToolViewHeight);
    self.openButton.selected = NO;
}

#pragma mark - 添加视图控件
- (void)setViewUI {
    [self addSubview:self.openButton];
    [_openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 20));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.styleCollectionView];
    [_styleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(self).with.offset(0);
        make.top.equalTo(_openButton.mas_bottom).with.offset(-1);
    }];
    
    [self.styleCollectionView addSubview:self.tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_styleCollectionView);
        make.right.equalTo(_styleCollectionView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
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
        _openButton.selected = NO;
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

#pragma mark - 提示语
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _tipLabel.text = @"文字颜色与背景";
    }
    return _tipLabel;
}

#pragma mark - 颜色按钮
- (UICollectionView *)styleCollectionView {
    if (!_styleCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(50, 50);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _styleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
        _styleCollectionView.backgroundColor = [UIColor whiteColor];
        _styleCollectionView.delegate = self;
        _styleCollectionView.dataSource = self;
        _styleCollectionView.showsHorizontalScrollIndicator = NO;
        [_styleCollectionView registerClass:[FYYColorCollectionViewCell class] forCellWithReuseIdentifier:ColorCellId];
    }
    return _styleCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _colorArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FYYColorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ColorCellId
                                                                                 forIndexPath:indexPath];
    [cell fyy_setTextColor:_colorArr[indexPath.row] paperImage:[NSString stringWithFormat:@"background_paper_%zi", indexPath.row + 1]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tool_delegate respondsToSelector:@selector(fyy_changeWriteTextColor:)]) {
        [self.tool_delegate fyy_changeWriteTextColor:_colorArr[indexPath.row]];
    }
    
    if ([self.tool_delegate respondsToSelector:@selector(fyy_changeWriteTextPaper:)]) {
        [self.tool_delegate fyy_changeWriteTextPaper:[NSString stringWithFormat:@"background_paper_%zi", indexPath.row + 1]];
    }
}

@end
