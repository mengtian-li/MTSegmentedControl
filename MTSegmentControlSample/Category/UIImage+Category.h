//
//  UIImage+Category.h
//  MTSegmentControlSample
//
//  Created by LiMengtian on 2017/4/4.
//  Copyright © 2017年 LiMengtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

+ (UIImage *)imageWithColor: (UIColor *)color;
+ (UIImage *)imageWithColor:(CGColorRef )color inRect: (CGRect)rect;

@end
