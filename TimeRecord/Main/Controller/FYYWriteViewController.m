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
}

#pragma mark - 懒加载视图
- (FYYWriteView *)writeView {
    if (!_writeView) {
        _writeView = [[FYYWriteView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_writeView fyy_setWriteBackgroundImage:@"background_paper_1"];
        [_writeView fyy_showTimeStamp:YES];
    }
    return _writeView;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
