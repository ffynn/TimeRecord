//
//  FYYWriteView.m
//  TimeRecord
//
//  Created by FLYang on 2017/3/15.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import "FYYWriteView.h"
#import "FYYPromptView.h"

static const NSInteger MAX_TITLE_TEXT = 18;

@implementation FYYWriteView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setViewUI];
    }
    return self;
}

#pragma mark - 设置视图控件布局
- (void)setViewUI {
    [self set_addTitleInputBoxView];
    
//    [self addSubview:self.editStyleButton];
//    [_editStyleButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH *0.2));
//        make.left.equalTo(self.mas_left).with.offset(0);
//        make.top.equalTo(_titleInputBox.mas_bottom).with.offset(10);
//    }];
    
}

#pragma mark - 设置背景稿纸
- (void)fyy_setWriteBackgroundImage:(NSString *)image {
    if (image.length) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:image]];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - 标题输入框
- (void)set_addTitleInputBoxView {
    [self addSubview:self.titleInputBox];
    [_titleInputBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@40);
        make.top.equalTo(self.mas_top).with.offset(30);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.titlePlaceholder];
    [_titlePlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_titleInputBox);
    }];
    
    [self addSubview:self.titleLeftView];
    [_titleLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.equalTo(_titleInputBox.mas_left).with.offset(0);
        make.centerY.equalTo(_titleInputBox);
    }];
    
    [self addSubview:self.titleRightView];
    [_titleRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.left.equalTo(_titleInputBox.mas_right).with.offset(0);
        make.centerY.equalTo(_titleInputBox);
    }];
}

- (UITextView *)titleInputBox {
    if (!_titleInputBox) {
        _titleInputBox = [[UITextView alloc] init];
        _titleInputBox.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.0f];
        _titleInputBox.font = [UIFont fontWithName:FONT_NAME size:22.0f];
        _titleInputBox.textColor = [UIColor colorWithHexString:FONT_COLOR];
        _titleInputBox.textAlignment = NSTextAlignmentCenter;
        _titleInputBox.scrollEnabled = NO;
        _titleInputBox.inputAccessoryView = self.accessoryView;
        _titleInputBox.delegate = self;
    }
    return _titleInputBox;
}

- (UILabel *)titlePlaceholder {
    if (!_titlePlaceholder) {
        _titlePlaceholder = [[UILabel alloc] init];
        _titlePlaceholder.font = [UIFont fontWithName:FONT_NAME size:22.0f];
        _titlePlaceholder.textColor = [UIColor colorWithHexString:FONT_COLOR];
        _titlePlaceholder.textAlignment = NSTextAlignmentCenter;
        _titlePlaceholder.text = @"输入标题";
    }
    return _titlePlaceholder;
}

- (UIImageView *)titleLeftView {
    if (!_titleLeftView) {
        _titleLeftView = [[UIImageView alloc] init];
        _titleLeftView.image = [UIImage imageNamed:@"icon_green_left"];
        _titleLeftView.contentMode = UIViewContentModeCenter;
    }
    return _titleLeftView;
}

- (UIImageView *)titleRightView {
    if (!_titleRightView) {
        _titleRightView = [[UIImageView alloc] init];
        _titleRightView.image = [UIImage imageNamed:@"icon_green_right"];
        _titleRightView.contentMode = UIViewContentModeCenter;
    }
    return _titleRightView;
}

#pragma mark 输入标题
//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    if (textView == self.titleInputBox) {
//        self.titlePlaceholder.alpha = 0.0f;
//    }
//}

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    if (textView == self.titleInputBox) {
//        self.titlePlaceholder.alpha = 0.0f;
//        return YES;
//    }
//    return NO;
//}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.titleInputBox) {
        NSString *titleText = textView.text;
        if (titleText.length == 0) {
            self.titlePlaceholder.alpha = 1.0f;
        } else {
            self.titlePlaceholder.alpha = 0.0f;
            if (titleText.length > MAX_TITLE_TEXT) {
                [FYYPromptView showWithText:@"标题最多可输入18个字符" status:(PromptStatusWarning)];
                textView.text = [titleText substringToIndex:MAX_TITLE_TEXT];
            }
        }
        [self changeTitleInputBoxFrame:textView.text];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == self.titleInputBox) {
        if (textView.text.length == 0) {
            self.titlePlaceholder.alpha = 1.0f;
        }
    }
}

#pragma mark 改变标题输入框的宽高
/**
 改变标题输入框的宽高

 @param text 输入的文字
 */
- (void)changeTitleInputBoxFrame:(NSString *)text {
    //  标题清空恢复默认文字
    if (text.length == 0) {
        text = @"输入标题";
    }
    
    //  行数
    NSInteger lineNum = 1;
    if (text.length > 9) {
        text = [text substringToIndex:9];
        lineNum += 1;
    }
    
    //  重新计算宽高
    CGFloat textWidth = [self getTextSizeWidth:text font:22.0f].width +20;
    CGFloat textHeight = [self getTextSizeWidth:text font:22.0f].height *lineNum +(lineNum == 2 ? 25 : 20);
    [self.titleInputBox mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(textWidth));
        make.height.mas_equalTo(@(textHeight));
    }];
}

#pragma mark - 正文输入框
- (UIButton *)editStyleButton {
    if (!_editStyleButton) {
        _editStyleButton = [[UIButton alloc] init];
        _editStyleButton.backgroundColor = [UIColor grayColor];
    }
    return _editStyleButton;
}

#pragma mark - 键盘工具操作
- (FYYAccessoryView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [[FYYAccessoryView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _accessoryView.delegate = self;
    }
    return _accessoryView;
}

#pragma mark 取消键盘响应
- (void)fyy_writeInputBoxResignFirstResponder {
    [self.titleInputBox resignFirstResponder];
}

#pragma mark 内容插入图片
- (void)fyy_writeInputBoxInsertImage {
    NSLog(@"--- 插入图片");
}

#pragma mark 保存草稿
- (void)fyy_writeInputBoxSaveDraft {
    NSLog(@"--- 保存草稿");
}

#pragma mark - 获取输入文字的Size
/**
 获取文字的Size
 
 @param text 输入的文字
 @param fontSize 文字字号
 @return 文字的Size
 */
- (CGSize)getTextSizeWidth:(NSString *)text font:(CGFloat)fontSize {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME size:fontSize]};
    
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0)
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading |
                      NSStringDrawingUsesDeviceMetrics
                                     attributes:attribute
                                        context:nil].size;
    return retSize;
}

#pragma mark - 获取字体
- (void)fyy_getFontName {
    NSArray *fontArr = [UIFont familyNames];
    for (NSString *famName in fontArr) {
        NSLog(@"%s", [famName UTF8String]);
        
        NSArray *fontNames = [UIFont fontNamesForFamilyName:famName];
        for( NSString *fontName in fontNames ){
            NSLog(@"字体: %s \n", [fontName UTF8String] );
        }
        
        NSLog(@"--------------------");
    }
}


@end
