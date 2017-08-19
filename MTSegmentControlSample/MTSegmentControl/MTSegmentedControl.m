//
//  MTSegmentControl.m
//  MTSegmentControlSample
//
//  Created by LiMengtian on 2017/4/4.
//  Copyright © 2017年 LiMengtian. All rights reserved.
//

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define kSegmentControlHeight 29.0

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "MTSegmentedControl.h"
#import "UIImage+Category.h"
#import "MTSegmentedButton.h"

@interface MTSegmentedControl ()<MTSegmentedButtonDelegate>

@property (nonatomic, strong) NSMutableArray <MTSegmentedButton *> * buttons;
@property (nonatomic, copy) NSArray <NSString *> * items;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation MTSegmentedControl

#pragma mark - life cycle

- (instancetype)init {
    return [self initWithItem:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithItem:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithItem:nil];
}

- (instancetype)initWithItem:(NSArray<NSString *> *)items {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.items = items;
        
        _selectedSegmentIndex = 0;
    
        [self setupDefaultConfiguration];
        [self setupSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [self setupConstraints];
}

#pragma mark - private

- (void)setupDefaultConfiguration {
    self.borderColor = UIColorFromRGB(0x333333);
    self.borderWidth = 2.0;
    self.borderRadius = 5.0;
    
    _selectedItemBackgroudColor = UIColorFromRGB(0x333333);
    _selectedItemTitleColor = UIColorFromRGB(0xffffff);
    
    _unSelectedItemBackgroundColor = UIColorFromRGB(0xffffff);
    _unSelectedItemTitleColor = UIColorFromRGB(0x333333);
    _unSelectedItemHighlightedBackgroundColor = UIColorFromRGB(0xf2f2f2);
    _unSelectedItemHighlightedTitleColor = UIColorFromRGB(0x303030);
}

- (void)setupSubViews {
    
    [self addSubview:self.contentView];
    
    self.buttons = [NSMutableArray arrayWithCapacity:self.items.count];
    
    for (int i = 0; i < self.items.count; i++) {
        NSString *item = [self.items objectAtIndex:i];
        MTSegmentedButton *button = [MTSegmentedButton buttonWithType:UIButtonTypeCustom];
        button.delegate = self;
        [self button:button setTitle:item];
        [button sizeToFit];
        if (_selectedSegmentIndex == i) {
            button.type = MTSegmentControlButtonTypeSelected;
        } else {
            button.type = MTSegmentControlButtonTypeUnSelectedNormal;
        }
        
        [self.contentView addSubview:button];
        [self.buttons addObject:button];
    }
}

- (void)setupConstraints {
    
    [self removeConstraints:self.constraints];
    [self.contentView removeConstraints:self.contentView.constraints];
    
    MTSegmentedButton *lastButton = nil;
    
    NSInteger count = self.items.count;
    CGFloat width = (self.bounds.size.width - ( count + 1 ) * _borderWidth ) / count;
    CGFloat height = self.bounds.size.height - 2 * _borderWidth;

    for (int i = 0; i < self.buttons.count; i++) {
        MTSegmentedButton *button = [self.buttons objectAtIndex:i];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        
        [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:width]];
        [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:height]];
        
        if (0 == i) {
            //first
            [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:_borderWidth]];
        } else if (self.buttons.count - 1 == i) {
            //last
            [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-_borderWidth]];
        } else {
            //others
            [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastButton attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:_borderWidth]];
        }
        lastButton = button;
    }
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
}

- (void)button: (MTSegmentedButton *)button setTitle: (NSString *)title {
    if ([title isKindOfClass:[NSString class]] && [title length] > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateSelected];
        [button setTitle:title forState:UIControlStateHighlighted];
    }
}

- (void)loadButtonResourceWithType:(MTSegmentControlButtonType)type {
    for (MTSegmentedButton *button in self.buttons) {
        if (type == button.type) {
            [button loadResource];
        }
    }
}
 
#pragma mark - Getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.masksToBounds = YES;
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentView;
}

#pragma mark - Setter

- (void)setBorderColor:(UIColor *)borderColor {
    if (!CGColorEqualToColor(_borderColor.CGColor, borderColor.CGColor)) {
        _borderColor = borderColor;
        self.contentView.layer.borderColor = _borderColor.CGColor;
        self.contentView.backgroundColor = _borderColor;
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (_borderWidth != borderWidth) {
        _borderWidth = borderWidth;
         self.contentView.layer.borderWidth = _borderWidth;
    }
}

- (void)setBorderRadius:(CGFloat)borderRadius {
    if (_borderRadius != borderRadius) {
        _borderRadius = borderRadius;
        self.contentView.layer.cornerRadius = _borderRadius;
    }
}

- (void)setSelectedItemBackgroudColor:(UIColor *)selectedItemBackgroudColor {
    if (!CGColorEqualToColor(_selectedItemBackgroudColor.CGColor, selectedItemBackgroudColor.CGColor)) {
        _selectedItemBackgroudColor = selectedItemBackgroudColor;
        [self loadButtonResourceWithType:MTSegmentControlButtonTypeSelected];
    }
}

- (void)setSelectedItemTitleColor:(UIColor *)selectedItemTitleColor {
    if (!CGColorEqualToColor(_selectedItemTitleColor.CGColor, selectedItemTitleColor.CGColor)) {
        _selectedItemTitleColor = selectedItemTitleColor;
        [self loadButtonResourceWithType:MTSegmentControlButtonTypeSelected];
    }
}

- (void)setUnSelectedItemBackgroundColor:(UIColor *)unSelectedItemBackgroundColor {
    if (!CGColorEqualToColor(_unSelectedItemBackgroundColor.CGColor, unSelectedItemBackgroundColor.CGColor)) {
        _unSelectedItemBackgroundColor = unSelectedItemBackgroundColor;
        [self loadButtonResourceWithType:MTSegmentControlButtonTypeUnSelectedNormal];
    }
}

- (void)setUnSelectedItemTitleColor:(UIColor *)unSelectedItemTitleColor {
    if (!CGColorEqualToColor(_unSelectedItemTitleColor.CGColor, unSelectedItemTitleColor.CGColor)) {
        _unSelectedItemTitleColor = unSelectedItemTitleColor;
        [self loadButtonResourceWithType:MTSegmentControlButtonTypeUnSelectedNormal];
    }
}

- (void)setUnSelectedItemHighlightedBackgroundColor:(UIColor *)unSelectedItemHighlightedBackgroundColor {
    if (!CGColorEqualToColor(_unSelectedItemHighlightedBackgroundColor.CGColor, unSelectedItemHighlightedBackgroundColor.CGColor)) {
        _unSelectedItemHighlightedBackgroundColor = unSelectedItemHighlightedBackgroundColor;
        [self loadButtonResourceWithType:MTSegmentControlButtonTypeUnSelectedHighlighted];
    }
}

- (void)setUnSelectedItemHighlightedTitleColor:(UIColor *)unSelectedItemHighlightedTitleColor {
    if (!CGColorEqualToColor(_unSelectedItemHighlightedTitleColor.CGColor, unSelectedItemHighlightedTitleColor.CGColor)) {
        _unSelectedItemHighlightedTitleColor = unSelectedItemHighlightedTitleColor;
        [self loadButtonResourceWithType:MTSegmentControlButtonTypeUnSelectedHighlighted];
    }
}

- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex {
    if (_selectedSegmentIndex == selectedSegmentIndex || selectedSegmentIndex >= self.items.count) {
        return;
    }
    MTSegmentedButton *prevButton = [self.buttons objectAtIndex:_selectedSegmentIndex];
    MTSegmentedButton *currentButton = [self.buttons objectAtIndex:selectedSegmentIndex];
    prevButton.type = MTSegmentControlButtonTypeUnSelectedNormal;
    currentButton.type = MTSegmentControlButtonTypeSelected;
    
    _selectedSegmentIndex = selectedSegmentIndex;
}

#pragma mark - MTSegmentedButtonDelegate 

- (UIImage *)selectedImage {
    return [UIImage imageWithColor:_selectedItemBackgroudColor];
}

- (UIColor *)selectedTitleColor {
    return _selectedItemTitleColor;
}

- (UIImage *)unSelectedNormalImage {
    return [UIImage imageWithColor:_unSelectedItemBackgroundColor];
}

- (UIColor *)unSelectedNormalTitleColor {
    return self.unSelectedItemTitleColor;
}

- (UIImage *)unSelectedHighlightedImage {
    return [UIImage imageWithColor:_unSelectedItemHighlightedBackgroundColor];
}

- (UIColor *)unSelectedHighlightedTitleColor {
    return _unSelectedItemHighlightedTitleColor;
}

- (void)itemSelected:(MTSegmentedButton *)button {
    NSInteger index = [self.buttons indexOfObject:button];
    self.selectedSegmentIndex = index;
    
    if (self.segmentControlSelectedHanlder) {
        self.segmentControlSelectedHanlder(index);
    }
}

@end
