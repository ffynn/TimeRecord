//
//  UIImage+Helper.h
//  FLyang
//
//  Created by FLyang on 15/3/31.
//  Copyright (c) 2015年 FLyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)

#pragma mark 默认从图片中心点开始拉伸图片
+ (UIImage *)resizedImage:(NSString *)imgName;

#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

// 圆形裁剪
+ (UIImage *)imageWithClipImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color;

// 控件截屏
+ (UIImage *)imageWithCaputureView:(UIView *)view;

@end

