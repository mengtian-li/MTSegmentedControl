//
//  UIImage+Category.m
//  MTSegmentControlSample
//
//  Created by LiMengtian on 2017/4/4.
//  Copyright © 2017年 LiMengtian. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color.CGColor inRect:CGRectMake(0, 0, 1.0, 1.0)];
}

+ (UIImage *)imageWithColor:(CGColorRef)cgColor inRect:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, cgColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
