//
//  FYYWriteViewController.h
//  TimeRecord
//
//  Created by FLYang on 2017/3/15.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import "FYYViewController.h"
#import "FYYWriteView.h"
#import "FYYStyleToolView.h"

@interface FYYWriteViewController : FYYViewController <
    FYYWriteDelegate,
    FYYStyleToolViewDelegate
>

/**
 书写文字的视图
 */
@property (nonatomic, strong) FYYWriteView *writeView;

/**
 样式工具视图
 */
@property (nonatomic, strong) FYYStyleToolView *toolView;

@end
