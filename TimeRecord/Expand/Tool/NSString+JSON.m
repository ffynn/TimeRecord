//
//  NSString+JSON.m
//  Read
//
//  Created by FLYang on 2017/1/10.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString(JSON)

+ (NSString *)jsonStringWithObject:(id)object {
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:(NSJSONWritingPrettyPrinted) error:nil];
    return [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
}

@end
