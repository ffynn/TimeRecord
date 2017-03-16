//
//  UIImage+QRCode.h
//  Fiu
//
//  Created by FLYang on 2017/3/13.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QRCode)

/**
 生成二维码图片

 @param url 链接
 @return 二维码
 */
+ (UIImage *)creatQRCodeImageForLinkUrl:(NSString *)url width:(CGFloat)width;

+ (UIImage *)generateQRCodeimagesForCIImage:(CIImage *)ciImage width:(CGFloat)width;

@end
