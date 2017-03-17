//
//  FYYWriteViewController.m
//  TimeRecord
//
//  Created by FLYang on 2017/3/15.
//  Copyright © 2017年 Fynn. All rights reserved.
//

#import "FYYWriteViewController.h"

@interface FYYWriteViewController ()

@end

@implementation FYYWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self set_controllerViewUI];
}

#pragma mark - 设置视图
- (void)set_controllerViewUI {
    [self.view addSubview:self.writeView];
    
    [self.view addSubview:self.toolView];
}

#pragma mark - 懒加载视图
- (FYYWriteView *)writeView {
    if (!_writeView) {
        _writeView = [[FYYWriteView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_writeView fyy_setWriteBackgroundImage:@"background_paper_1"];
        [_writeView fyy_showTimeStamp:YES];
        _writeView.write_delegate = self;
    }
    return _writeView;
}

/**
 开始输入
 */
- (void)fyy_beginWrite {
    if (CGRectGetMinY(self.toolView.frame) < SCREEN_HEIGHT - 30) {
        [self.toolView fyy_restoreTheDefault];
    }
}

- (FYYStyleToolView *)toolView {
    if (!_toolView) {
        _toolView = [[FYYStyleToolView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 90)];
        _toolView.tool_delegate = self;
    }
    return _toolView;
}

/**
 改变字体颜色
 */
- (void)fyy_changeWriteTextColor:(NSString *)color {
    [self.writeView fyy_setWriteTextColor:color];
}

#pragma mark - 系统状态栏样式
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
