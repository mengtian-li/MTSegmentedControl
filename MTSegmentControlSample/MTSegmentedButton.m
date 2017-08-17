//
//  MTSegmentedButton.m
//  MTSegmentControlSample
//
//  Created by LiMengtian on 16/08/2017.
//  Copyright © 2017 LiMengtian. All rights reserved.
//

#import "MTSegmentedButton.h"

@implementation MTSegmentedButton

- (void)setType:(MTSegmentControlButtonType)type {
    _type = type;
    switch (type) {
        case MTSegmentControlButtonTypeSelected:
            [self loadResourceForSelectedState];
            break;
        case MTSegmentControlButtonTypeUnSelected:
            [self loadResourceForUnselectedNormalState];
            break;
        case MTSegmentControlButtonTypeHighlighted:
            [self loadResourceForUnSelectedHighlightedState];
            break;
        default:
            break;
    }
}

#pragma mark - UIHelper

- (void)loadResourceForSelectedState {
    [self loadBackgroundImage:[self selectedImage] titleColor:[self selectedTitleColor]];
}

- (void)loadResourceForUnselectedNormalState {
    [self loadBackgroundImage:[self unSelectedNormalImage] titleColor:[self unSelectedNormalTitleColor]];
}

- (void)loadResourceForUnSelectedHighlightedState {
    [self loadBackgroundImage:[self unSelectedHighlightedImage] titleColor:[self unSelectedHighlightedTitleColor]];
}

- (void)loadBackgroundImage:(UIImage *)image
                 titleColor:(UIColor *)color {
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:image forState:UIControlStateSelected];
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateSelected];
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

#pragma mark - Resource

- (UIImage *)selectedImage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedImage)]) {
        return [self.delegate selectedImage];
    }
    return nil;
}

- (UIColor *)selectedTitleColor {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedTitleColor)]) {
        return [self.delegate selectedTitleColor];
    }
    return nil;
}

- (UIImage *)unSelectedNormalImage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(unSelectedNormalImage)]) {
        return [self.delegate unSelectedNormalImage];
    }
    return nil;
}

- (UIColor *)unSelectedNormalTitleColor {
    if (self.delegate && [self.delegate respondsToSelector:@selector(unSelectedNormalTitleColor)]) {
        return [self.delegate unSelectedNormalTitleColor];
    }
    return nil;
}

- (UIImage *)unSelectedHighlightedImage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(unSelectedHighlightedImage)]) {
        return [self.delegate unSelectedHighlightedImage];
    }
    return nil;
}

- (UIColor *)unSelectedHighlightedTitleColor {
    if (self.delegate && [self.delegate respondsToSelector:@selector(unSelectedHighlightedTitleColor)]) {
        return [self.delegate unSelectedHighlightedTitleColor];
    }
    return nil;
}

@end
