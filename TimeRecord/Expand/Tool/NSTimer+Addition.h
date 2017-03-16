//
//  NSTimer+Addition.h
//  Fiu
//
//  Created by FLYang on 16/5/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

//关闭定时器
- (void)pauseTimer;
//启动定时器
- (void)resumeTimer;
//添加一个定时器
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
