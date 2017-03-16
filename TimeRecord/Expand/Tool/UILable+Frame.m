//
//  UILable+Frame.m
//  Fiu
//
//  Created by FLYang on 16/4/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "UILable+Frame.h"

@implementation UILabel (Frame)

#pragma mark 获取UILable的size
- (CGSize)boundingRectWithSize:(CGSize)size {
    NSDictionary *attribute = @{NSFontAttributeName:self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading |
                      NSStringDrawingUsesDeviceMetrics
                                          attributes:attribute
                                             context:nil].size;
    return retSize;
}

@end
