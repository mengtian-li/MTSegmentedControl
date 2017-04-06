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

#import "MTSegmentedControl.h"
#import "UIImage+Category.h"

typedef NS_ENUM(NSInteger, MTSegmentControlButtonType) {
    MTSegmentControlButtonTypeSelected = 0, // selected
    MTSegmentControlButtonTypeUnSelected, // unselected normal
    MTSegmentControlButtonTypeHighlighted, // unselected highlighted
};

#define kSegmentControlHeight 29.0

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MTSegmentedControl ()

@property (nonatomic, strong) NSMutableArray <UIButton *> * buttons;
@property (nonatomic, strong) NSMutableArray <UIView *> *separateViews;
@property (nonatomic, copy) NSArray <NSString *> * items;

@property (nonatomic) CGFloat itemWidth;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *lastButton;

@property (nonatomic, copy) NSArray *itemWidthConstraints;
@property (nonatomic, copy) NSArray *itemHeightConstraints;


@end

@implementation MTSegmentedControl

#pragma mark - life cycle

- (instancetype)init {
    return [self initWithItem:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithItem:nil];
}

- (instancetype)initWithItem:(NSArray<NSString *> *)items {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.items = items;
        _buttons = [NSMutableArray arrayWithCapacity:items.count];
        
        _itemWidth = 0.0;
        _itemMargin = 5.0;
        
        _selectedSegmentIndex = 0;
        _borderColor = UIColorFromRGB(0x333333);
        _borderWidth = 2.0;
        _borderRadius = 5.0;
        
        _selectedItemBackgroudColor = UIColorFromRGB(0x333333);
        _selectedItemTitleColor = UIColorFromRGB(0xffffff);
        
        _unSelectedItemBackgroundColor = UIColorFromRGB(0xffffff);
        _unSelectedItemTitleColor = UIColorFromRGB(0x333333);
        _unSelectedItemHighlightedBackgroundColor = UIColorFromRGB(0xf2f2f2);
        _unSelectedItemHighlightedTitleColor = UIColorFromRGB(0x303030);
  
        [self setupButtons];
    }
    return self;
}


- (void)layoutSubviews {
    [self setupConstraints];
}


#pragma mark - private

- (void)setupButtons {
    [self setupSubViews];
}

- (void)setupSubViews {
    _contentView = [[UIView alloc] init];
    _contentView.layer.borderColor = _borderColor.CGColor;
    _contentView.layer.borderWidth = _borderWidth;
    _contentView.layer.cornerRadius = _borderRadius;
    _contentView.layer.masksToBounds = YES;
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.backgroundColor = _borderColor;
    
    [self addSubview:_contentView];
    
    for (int i = 0; i < self.items.count; i++) {
        NSString *item = [self.items objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self button:button setTitle:item];
        [button sizeToFit];
        _itemWidth = button.frame.size.width > _itemWidth ?  button.frame.size.width : _itemWidth;
        if (_selectedSegmentIndex == i) {
            [self button:button setType:MTSegmentControlButtonTypeSelected];
        } else {
            [self button:button setType:MTSegmentControlButtonTypeUnSelected];
        }
        
        [button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(touDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [button addTarget:self action:@selector(touchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:button];
        [self.buttons addObject:button];
    }
    

}

- (void)setupConstraints {
    
    [self removeConstraints:self.constraints];
    [_contentView removeConstraints:_contentView.constraints];
    
    UIButton *lastButton = nil;
    
    NSInteger count = self.items.count;
    CGFloat width = (self.bounds.size.width - ( count + 1 ) * _borderWidth ) / count;
    CGFloat height = self.bounds.size.height - 2 * _borderWidth;

    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *button = [self.buttons objectAtIndex:i];
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
        _lastButton = lastButton;
    }
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
}

- (void)button: (UIButton *)button setTitle: (NSString *)title {
    if ([title isKindOfClass:[NSString class]] && [title length] > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateSelected];
        [button setTitle:title forState:UIControlStateHighlighted];
    }
}

- (void)button: (UIButton *)button setBackgroundColor: (UIColor *)color {
    if ([color isKindOfClass:[UIColor class]]) {
        UIImage *colorImage = [UIImage imageWithColor:color];
        [button setBackgroundImage:colorImage forState:UIControlStateNormal];
        [button setBackgroundImage:colorImage forState:UIControlStateSelected];
        [button setBackgroundImage:colorImage forState:UIControlStateHighlighted];
    }
}

- (void)button: (UIButton *)button setTitleColor: (UIColor *)color {
    if ([color isKindOfClass:[UIColor class]]) {
        [button setTitleColor:color forState:UIControlStateNormal];
        [button setTitleColor:color forState:UIControlStateSelected];
        [button setTitleColor:color forState:UIControlStateHighlighted];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)button: (UIButton*)button setType: (MTSegmentControlButtonType)type {
    switch (type) {
        case MTSegmentControlButtonTypeSelected:
            [self button:button setBackgroundColor:self.selectedItemBackgroudColor];
            [self button:button setTitleColor:self.selectedItemTitleColor];
            break;
        case MTSegmentControlButtonTypeUnSelected:
            [self button:button setBackgroundColor:self.unSelectedItemBackgroundColor];
            [self button:button setTitleColor:self.unSelectedItemTitleColor];
            break;
        case MTSegmentControlButtonTypeHighlighted:
            [self button:button setBackgroundColor:self.unSelectedItemHighlightedBackgroundColor];
            [self button:button setTitleColor:self.unSelectedItemHighlightedTitleColor];
            break;
        default:
            break;
    }
}

#pragma mark - Action

- (void)touchDown: (UIButton *)button {
    DLog(@"%@",button);
    if (button == [self.buttons objectAtIndex:_selectedSegmentIndex]) {
        return;
    }
    
    [self button:button setType:MTSegmentControlButtonTypeHighlighted];
}

- (void)touDragExit: (UIButton *)button {
    DLog(@"%@",button);
    if (button == [self.buttons objectAtIndex:_selectedSegmentIndex]) {
        return;
    }
    
    [self button:button setType:MTSegmentControlButtonTypeUnSelected];
}

- (void)touchDragEnter: (UIButton *)button {
    DLog(@"%@",button);
    if (button == [self.buttons objectAtIndex:_selectedSegmentIndex]) {
        return;
    }
    [self button:button setType:MTSegmentControlButtonTypeHighlighted];
}

- (void)touchUpInside: (UIButton *)button {
    DLog(@"%@",button);
    if (button == [self.buttons objectAtIndex:_selectedSegmentIndex]) {
        return;
    }
    NSInteger index = [self.buttons indexOfObject:button];
    self.selectedSegmentIndex = index;
    
    if (self.segmentControlSelectedHanlder) {
        self.segmentControlSelectedHanlder(index);
    }
    
}

#pragma mark - Accessor 

- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex {
    if (_selectedSegmentIndex == selectedSegmentIndex || selectedSegmentIndex >= self.items.count) {
        return;
    }
    UIButton *prevButton = [self.buttons objectAtIndex:_selectedSegmentIndex];
    UIButton *currentButton = [self.buttons objectAtIndex:selectedSegmentIndex];
    [self button:prevButton setType:MTSegmentControlButtonTypeUnSelected];
    [self button:currentButton setType:MTSegmentControlButtonTypeSelected];
    
    _selectedSegmentIndex = selectedSegmentIndex;
}

@end
