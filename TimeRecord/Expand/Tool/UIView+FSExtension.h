//
//  UIView+FSExtension.h
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FSExtension)

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

+ (instancetype)viewFromXib;
- (void)circle:(NSInteger)r;

@end
