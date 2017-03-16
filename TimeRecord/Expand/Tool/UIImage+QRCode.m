//
//  UIImage+QRCode.m
//  Fiu
//
//  Created by FLYang on 2017/3/13.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "UIImage+QRCode.h"

@implementation UIImage (QRCode)

+ (UIImage *)creatQRCodeImageForLinkUrl:(NSString *)url width:(CGFloat)width {
    NSData *urlData = [url dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:urlData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    CIImage *ciImage = [qrFilter outputImage];
    return [self generateQRCodeimagesForCIImage:ciImage width:width];
}

+ (UIImage *)generateQRCodeimagesForCIImage:(CIImage *)ciImage width:(CGFloat)width {
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(width/CGRectGetWidth(extent), width/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t imageWidth = CGRectGetWidth(extent) * scale;
    size_t imageHeight = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, imageWidth, imageHeight, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
