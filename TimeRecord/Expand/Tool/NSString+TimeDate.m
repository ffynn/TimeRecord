//
//  NSString+TimeDate.m
//  Fiu
//
//  Created by FLYang on 2016/10/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "NSString+TimeDate.h"

@implementation NSString (TimeDate)

+ (NSString *)getTimesTamp:(NSInteger)time {
    NSDateFormatter *timeData = [[NSDateFormatter alloc] init];
    [timeData setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [timeData stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    return timeStr;
}

@end
