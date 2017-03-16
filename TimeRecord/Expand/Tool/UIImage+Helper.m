//
//  UIImage+Helper.m
//  FLyang
//
//  Created by FLyang on 15/3/31.
//  Copyright (c) 2015年 FLyang. All rights reserved.
//s

#import "UIImage+Helper.h"

@implementation UIImage (Helper)

#pragma mark 默认从图片中心点开始拉伸图片
+ (UIImage *)resizedImage:(NSString *)imgName {
    return [self resizedImage:imgName xPos:0.5 yPos:0.5];
}

#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos {
    UIImage *image = [UIImage imageNamed:imgName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * xPos topCapHeight:image.size.height * yPos];
}

#pragma mark - 调整拍照图片方向
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp) {
        return aImage;
    }
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


+ (UIImage *)imageWithClipImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color
{
    // 图片的宽度和高度
    CGFloat imageWH = image.size.width;
    
    // 设置圆环的宽度
    CGFloat border = borderWidth;
    
    // 圆形的宽度和高度
    CGFloat ovalWH = imageWH + 2 * border;
    
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ovalWH, ovalWH), NO, 0);
    
    // 2.画大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ovalWH, ovalWH)];
    
    [color set];
    
    [path fill];
    
    // 3.设置裁剪区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(border, border, imageWH, imageWH)];
    [clipPath addClip];
    
    // 4.绘制图片
    [image drawAtPoint:CGPointMake(border, border)];
    
    // 5.获取图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return clipImage;
    
}


+ (UIImage *)imageWithCaputureView:(UIView *)view
{
    // 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 把控件上的图层渲染到上下文,layer只能渲染
    [view.layer renderInContext:ctx];
    
    // 生成一张图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
