//
//  NSString+TimeDate.h
//  Fiu
//
//  Created by FLYang on 2016/10/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeDate)


/**
 转换时间戳格式

 @param time 时间戳

 @return 字符串时间
 */
+ (NSString *)getTimesTamp:(NSInteger)time;

@end
