//
//  FYYImageAttachment.m
//  TimeRecord
//
//  Created by FLYang on 2017/3/20.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import "FYYImageAttachment.h"

#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width

@implementation FYYImageAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    return CGRectMake(0, 0, _imageSize.width, _imageSize.height);
}

@end
