//
//  MTSegmentedButton.m
//  MTSegmentControlSample
//
//  Created by LiMengtian on 16/08/2017.
//  Copyright © 2017 LiMengtian. All rights reserved.
//

#import "MTSegmentedButton.h"

@implementation MTSegmentedButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    MTSegmentedButton *button = [super buttonWithType:buttonType];
    
    [button addTarget:button action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:button action:@selector(touDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [button addTarget:button action:@selector(touchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [button addTarget:button action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

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

#pragma mark - Action

- (void)touchDown:(MTSegmentedButton *)button {
    if (MTSegmentControlButtonTypeSelected == _type) {
        return;
    }
    button.type = MTSegmentControlButtonTypeHighlighted;
}

- (void)touDragExit:(MTSegmentedButton *)button {
    if (MTSegmentControlButtonTypeSelected == _type) {
        return;
    }
    button.type = MTSegmentControlButtonTypeUnSelected;
}

- (void)touchDragEnter:(MTSegmentedButton *)button {
    if (MTSegmentControlButtonTypeSelected == _type) {
        return;
    }
    button.type = MTSegmentControlButtonTypeHighlighted;
}

- (void)touchUpInside:(MTSegmentedButton *)button {
    if (MTSegmentControlButtonTypeSelected == _type) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemSelected:)]) {
        [self.delegate itemSelected:button];
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
