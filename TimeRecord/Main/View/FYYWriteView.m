//
//  FYYWriteView.m
//  TimeRecord
//
//  Created by FLYang on 2017/3/15.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import "FYYWriteView.h"
#import "FYYPromptView.h"
#import <TYAlertController/TYAlertController.h>
#import <TYAlertController/TYAlertView.h>
#import "FYYImageAttachment.h"
#import "UIImage+Helper.h"

static const NSInteger MAX_TITLE_COUNT = 18;
static const NSInteger BOTTOM_MARGIN = 70;
static const NSInteger TOP_MARGIN = 60;

@interface FYYWriteView () {
    CGFloat   _keyboardH;         //  弹出的键盘高度
    CGFloat   _contentTextH;      //  正文内容的高度
    NSString *_textColor;         //  文字颜色
    NSInteger _imageCount;        //  图片的数量
    CGFloat   _imageTotalHeight;  //  图片的总高度
}

/**
 记录改变字体的样式
 */
@property (nonatomic, strong) NSMutableAttributedString *contentAttributed;

/**
 更新内容的范围
 */
@property (nonatomic, assign) NSRange contentNewRange;

/**
 更新内容的文字
 */
@property (nonatomic , strong) NSString *contentNewText;

/**
 删除文字
 */
@property (nonatomic, assign) BOOL isDelete;

/**
 保存插入图片的数组
 */
@property (nonatomic, strong) NSMutableArray *imageAttachmentMarr;

@end

@implementation FYYWriteView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setViewUI];
        
        [self set_addNotification];
        [self set_initAttributedString];
    }
    return self;
}

#pragma mark - 设置视图控件布局
- (void)setViewUI {
    _textColor = @"#411616";
    
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_paper_1"]];
    self.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    self.showsVerticalScrollIndicator = NO;
    
    [self set_addTitleInputBoxView];
    [self set_addContentInputBoxView];
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
        _titleInputBox.textColor = [UIColor colorWithHexString:_textColor];
        _titleInputBox.textAlignment = NSTextAlignmentCenter;
        _titleInputBox.scrollEnabled = NO;
        _titleInputBox.returnKeyType = UIReturnKeyDone;
        _titleInputBox.inputAccessoryView = self.accessoryView;
        _titleInputBox.delegate = self;
        _titleInputBox.showsVerticalScrollIndicator = NO;
    }
    return _titleInputBox;
}

- (UILabel *)titlePlaceholder {
    if (!_titlePlaceholder) {
        _titlePlaceholder = [[UILabel alloc] init];
        _titlePlaceholder.font = [UIFont fontWithName:FONT_NAME size:22.0f];
        _titlePlaceholder.textColor = [UIColor colorWithHexString:_textColor alpha:0.8f];
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

#pragma mark 输入监测的代理
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self.titleInputBox) {
        [self.accessoryView setHiddenExtendingFunction:YES];
    } else if (textView == self.contentInputBox) {
        [self.accessoryView setHiddenExtendingFunction:NO];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == self.titleInputBox) {
        if ([text isEqualToString:@"\n"] || [text isEqualToString:@" "]) {
            textView.text = [textView.text stringByReplacingOccurrencesOfString:text withString:@""];
            
            if ([text isEqualToString:@"\n"]) {
                [self.titleInputBox resignFirstResponder];
                [self.contentInputBox becomeFirstResponder];
            }
            return NO;
        }
        
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.titleInputBox) {
        NSString *titleText = textView.text;
        if (titleText.length == 0) {
            self.titlePlaceholder.hidden = NO;
        } else {
            self.titlePlaceholder.hidden = YES;
            if (titleText.length > MAX_TITLE_COUNT) {
                [FYYPromptView showWithText:@"标题最多可输入18个字符" status:(PromptStatusWarning)];
                textView.text = [titleText substringToIndex:MAX_TITLE_COUNT];
            }
        }
        
        [self fyy_screeningInputHighlightingText:textView];
    
    } else if (textView == self.contentInputBox) {
        if (textView.attributedText.length > 0) {
            self.contentPlaceholder.hidden = YES;
        } else {
            self.contentPlaceholder.hidden = NO;
        }
        
        NSInteger textLength = textView.attributedText.length - self.contentAttributed.length;
        
        if (textLength > 0) {
            self.isDelete = NO;
            self.contentNewRange = NSMakeRange(textView.selectedRange.location - textLength, textLength);
            self.contentNewText = [textView.text substringWithRange:self.contentNewRange];
            
        } else {
            self.isDelete = YES;
        }
    
        [self fyy_screeningInputHighlightingText:textView];
    }
}

- (void)fyy_screeningInputHighlightingText:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    //  获取高亮部分
    UITextPosition *isHighlight = [textView positionFromPosition:selectedRange.start offset:0];
    //  没有高亮表示输入完成
    if (!isHighlight) {
        if (textView == self.titleInputBox) {
            [self changeTitleInputBoxFrame:textView.text];
            
        } else if (textView == self.contentInputBox) {
            [self getContentInputTextHeight:textView.text attributes:[self set_attributesDictionary]];
            [self setContentInputBoxTextStyle:textView];
        }
    }
}

#pragma mark 设置正文内容的文本样式
- (void)setContentInputBoxTextStyle:(UITextView *)textView {
    [self set_initAttributedString];
    
    if (self.isDelete) {
        return;
    }
    
    NSDictionary *attributesDict = [self set_attributesDictionary];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.contentNewText attributes:attributesDict];
    [self.contentAttributed replaceCharactersInRange:self.contentNewRange withAttributedString:attributedString];
    self.contentInputBox.attributedText = self.contentAttributed;
    self.contentInputBox.selectedRange = NSMakeRange(self.contentNewRange.location + self.contentNewRange.length, 0);
}

- (NSDictionary *)set_attributesDictionary {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 5.0f;
    
    NSDictionary *attributesDict = @{
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     NSForegroundColorAttributeName:[UIColor colorWithHexString:_textColor],
                                     NSFontAttributeName:[UIFont fontWithName:FONT_NAME size:16.0f]
                                     };
    return attributesDict;
}

#pragma mark 改变标题输入框的宽高
- (void)changeTitleInputBoxFrame:(NSString *)text {
    //  标题清空恢复默认文字
    if (text.length == 0) {
        text = @"输入标题";
    }
    
    //  折行
    NSInteger lineNum = 1;
    if (text.length > 9) {
        text = [text substringToIndex:9];
        lineNum += 1;
    }
    
    //  重新计算宽高
    CGFloat textWidth = [self getTextSizeWidth:text font:22.0f].width +25;
    CGFloat textHeight = [self getTextSizeWidth:text font:22.0f].height *lineNum +(lineNum == 2 ? 25 : 20);
    [self.titleInputBox mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(textWidth));
        make.height.mas_equalTo(@(textHeight));
    }];
}

#pragma mark - 正文输入框
- (void)set_addContentInputBoxView {
    [self addSubview:self.contentInputBox];
    [_contentInputBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH - 40);
        make.top.equalTo(_titleInputBox.mas_bottom).with.offset(30);
        make.bottom.equalTo(self.mas_top).with.offset(SCREEN_HEIGHT - BOTTOM_MARGIN);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.contentPlaceholder];
    [_contentPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentInputBox);
        make.top.left.right.equalTo(_contentInputBox).with.offset(0);
        make.height.mas_equalTo(@35);
    }];
}

- (UITextView *)contentInputBox {
    if (!_contentInputBox) {
        _contentInputBox = [[UITextView alloc] init];
        _contentInputBox.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.0f];
        _contentInputBox.textAlignment = NSTextAlignmentCenter;
        _contentInputBox.inputAccessoryView = self.accessoryView;
        _contentInputBox.font = [UIFont fontWithName:FONT_NAME size:16.0f];
        _contentInputBox.textColor = [UIColor colorWithHexString:_textColor];
        _contentInputBox.scrollEnabled = NO;
        _contentInputBox.delegate = self;
        _contentInputBox.showsVerticalScrollIndicator = NO;
    }
    return _contentInputBox;
}

- (UILabel *)contentPlaceholder {
    if (!_contentPlaceholder) {
        _contentPlaceholder = [[UILabel alloc] init];
        _contentPlaceholder.font = [UIFont fontWithName:FONT_NAME size:16.0f];
        _contentPlaceholder.textColor = [UIColor colorWithHexString:_textColor alpha:0.7f];
        _contentPlaceholder.textAlignment = NSTextAlignmentCenter;
        _contentPlaceholder.text = @"输入正文";
    }
    return _contentPlaceholder;
}

#pragma mark 正文文字的高度
- (void)getContentInputTextHeight:(NSString *)text attributes:(NSDictionary *)attributes {
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT)
                                            options:\
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                         attributes:attributes
                                            context:nil].size;
    
    _contentTextH = textSize.height;
}

#pragma mark - 底部打开编辑样式的按钮
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
    if (self.titleInputBox.isFirstResponder) {
        [self.titleInputBox resignFirstResponder];
        
    } else if (self.contentInputBox.isFirstResponder) {
        [self.contentInputBox resignFirstResponder];
    }
    
    _imageCount = [self getTextAttachmentImageCount];
    [self adjustTheHeightOfTheWriteView:NO];
}

#pragma mark 内容插入图片
- (void)fyy_writeInputBoxInsertImage {
    [self openImagePickerChoosePhoto];
}

- (void)openImagePickerChoosePhoto {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"插入图片" message:nil];
    alertView.buttonDefaultBgColor = [UIColor colorWithHexString:@"#A04949"];
    alertView.buttonCancelBgColor = [UIColor colorWithHexString:@"#999999"];
    [alertView addAction:[TYAlertAction actionWithTitle:@"拍照" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        [self takePhoto];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"本地相册" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        [self openPhotoLibrary];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:nil]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [self.vc presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 拍照
- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self presentImagePickerController:UIImagePickerControllerSourceTypeCamera];
    }
}

#pragma mark 打开相册
- (void)openPhotoLibrary {
    [self presentImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)presentImagePickerController:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    [self.vc presentViewController:picker animated:YES completion:nil];
}

#pragma mark 获取图片完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self insertImageOfTheTextView:self.contentInputBox withImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 指定位置插入图片
- (void)insertImageOfTheTextView:(UITextView *)textView withImage:(UIImage *)image {
    if (image == nil || ![image isKindOfClass:[UIImage class]]) {
        return;
    }
    
    FYYImageAttachment *attachment = [[FYYImageAttachment alloc] init];
    attachment.image = image;
    attachment.imageSize = [self scaleImageSize:image];
    
    NSAttributedString *imageAttributedString = [self insertImageDoneAutoReturn:[NSAttributedString attributedStringWithAttachment:attachment]];
    [textView.textStorage insertAttributedString:imageAttributedString atIndex:textView.selectedRange.location];
    textView.selectedRange = NSMakeRange(textView.selectedRange.location + 3, 0);
    
    [self set_initAttributedString];
}

#pragma mark 缩放插入的图片尺寸
- (CGSize)scaleImageSize:(UIImage *)image {
    CGFloat imageScale = image.size.width / image.size.height;
    CGFloat imageWidth = SCREEN_WIDTH - 40;
    CGSize imageSize = CGSizeMake(imageWidth, imageWidth / imageScale);
    return imageSize;
}

#pragma mark - 插入图片后换行
- (NSAttributedString *)insertImageDoneAutoReturn:(NSAttributedString *)imageAttributedString {
    NSAttributedString *returnAttributedString = [[NSAttributedString alloc] initWithString:@"\n"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:imageAttributedString];
    [attributedString appendAttributedString:returnAttributedString];
    [attributedString insertAttributedString:returnAttributedString atIndex:1];
    [attributedString addAttributes:[self set_attributesDictionary] range:NSMakeRange(0, self.contentInputBox.selectedRange.location + 3)];
    return attributedString;
}

#pragma mark - 遍历获取文本内容中的图片数量
- (NSInteger)getTextAttachmentImageCount {
    _imageTotalHeight = 0.0f;
    [self.imageAttachmentMarr removeAllObjects];
    [self.contentInputBox.attributedText enumerateAttribute:NSAttachmentAttributeName
                                                    inRange:NSMakeRange(0, self.contentInputBox.attributedText.length)
                                                    options:NSAttributedStringEnumerationReverse
                                                 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                                                     if (value && [value isKindOfClass:[FYYImageAttachment class]]) {
                                                         [self.imageAttachmentMarr addObject:value];
                                                     }
                                                 }];
    for (FYYImageAttachment *attachment in self.imageAttachmentMarr) {
        _imageTotalHeight += attachment.imageSize.height;
    }
    return self.imageAttachmentMarr.count;
}

#pragma mark - 初始化字体样式
- (void)set_initAttributedString {
    self.contentAttributed = nil;
    
    self.contentAttributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentInputBox.attributedText];
    if (self.contentInputBox.textStorage.length > 0) {
        self.contentPlaceholder.hidden = YES;
        [self.contentInputBox becomeFirstResponder];
    } else {
        self.contentPlaceholder.hidden = NO;
    }
}

#pragma mark 保存草稿
- (void)fyy_writeInputBoxSaveDraft {
    NSLog(@"--- 保存草稿");
}

#pragma mark - 设置时间戳
- (void)fyy_showTimeStamp:(BOOL)show {
    if (show) {
        self.timeStamp.text = [self systemTimeDate];
        [self addSubview:self.timeStamp];
        [_timeStamp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 15));
            make.top.equalTo(_contentInputBox.mas_bottom).with.offset(10);
            make.centerX.equalTo(self);
        }];
    }
}

- (UILabel *)timeStamp {
    if (!_timeStamp) {
        _timeStamp = [[UILabel alloc] init];
        _timeStamp.font = [UIFont fontWithName:FONT_NAME size:14.0f];
        _timeStamp.textColor = [UIColor colorWithHexString:_textColor alpha:0.7f];
        _timeStamp.textAlignment = NSTextAlignmentCenter;
    }
    return _timeStamp;
}

- (NSString *)systemTimeDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSString *timeDate = [formatter stringFromDate:[NSDate date]];
    return timeDate;
}

#pragma mark - 获取输入文字的Size
- (CGSize)getTextSizeWidth:(NSString *)text font:(CGFloat)fontSize {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME size:fontSize]};
    
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0)
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize;
}

#pragma mark - 监测键盘是否启用
- (void)set_addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fyy_getKeyboardFrameHeightOfShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fyy_getKeyboardFrameHeightOfHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 键盘弹出
- (void)fyy_getKeyboardFrameHeightOfShow:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardH = keyboardRect.size.height;
    
    self.contentOffset = CGPointMake(0, 0);
    self.contentInputBox.scrollEnabled = YES;
    [self adjustTheHeightOfTheWriteView:YES];
    
    if ([self.write_delegate respondsToSelector:@selector(fyy_beginWrite)]) {
        [self.write_delegate fyy_beginWrite];
    }
}

#pragma mark 键盘落下
- (void)fyy_getKeyboardFrameHeightOfHide:(NSNotification *)aNotification {
    self.contentInputBox.scrollEnabled = NO;
    
    if ([self.write_delegate respondsToSelector:@selector(fyy_endWrite)]) {
        [self.write_delegate fyy_endWrite];
    }
}

#pragma mark - 调整正文输入框的高度
- (void)adjustTheHeightOfTheWriteView:(BOOL)keyboardShow {
    if (keyboardShow) {
        [self.contentInputBox mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top).with.offset(SCREEN_HEIGHT - (_keyboardH + 10));
        }];
    } else {
        [self fyy_adjustWriteViewHightForShowAllText];
    }
}

#pragma mark 调整整个文稿的高度以展开显示全部的文本
- (void)fyy_adjustWriteViewHightForShowAllText {
    CGFloat titleInputH = CGRectGetHeight(self.titleInputBox.frame) + TOP_MARGIN;
    CGFloat marginH = SCREEN_HEIGHT - titleInputH - BOTTOM_MARGIN;
    CGFloat contentH = _contentTextH + _imageTotalHeight + (_imageCount * 20);
    CGFloat contentSizeH = titleInputH + contentH + BOTTOM_MARGIN;
    
    if (contentH > marginH) {
        [self.contentInputBox mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top).with.offset(titleInputH + contentH);
        }];
        self.contentSize = CGSizeMake(SCREEN_WIDTH, contentSizeH);
        
    } else {
        [self.contentInputBox mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top).with.offset(SCREEN_HEIGHT - BOTTOM_MARGIN);
        }];
        
        self.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}

#pragma mark - 改变字体颜色
- (void)fyy_setWriteTextColor:(NSString *)color {
    _textColor = color;
    [self changeWriteTextColor:color];
}

- (void)changeWriteTextColor:(NSString *)color {
    self.titleInputBox.textColor = [UIColor colorWithHexString:color alpha:1.0f];
    self.contentInputBox.textColor = [UIColor colorWithHexString:color alpha:1.0f];
    self.titlePlaceholder.textColor = [UIColor colorWithHexString:color alpha:0.8f];
    self.contentPlaceholder.textColor = [UIColor colorWithHexString:color alpha:0.7f];
    self.timeStamp.textColor = [UIColor colorWithHexString:color alpha:0.7f];
}

#pragma mark - 改变稿纸背景
- (void)fyy_setWriteViewPaper:(NSString *)paper {
    if (paper.length) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:paper]];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 
- (NSMutableArray *)imageAttachmentMarr {
    if (!_imageAttachmentMarr) {
        _imageAttachmentMarr = [NSMutableArray array];
    }
    return _imageAttachmentMarr;
}

@end
