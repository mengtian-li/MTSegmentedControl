//
//  MTSegmentControl.h
//  MTSegmentControlSample
//
//  Created by LiMengtian on 2017/4/4.
//  Copyright © 2017年 LiMengtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTSegmentedControl : UIView

@property (nonatomic) NSUInteger selectedSegmentIndex;
//margin
//@property (nonatomic) CGFloat itemMargin;
//border
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat borderRadius;
//selected state
@property (nonatomic, strong) UIColor *selectedItemBackgroudColor;
@property (nonatomic, strong) UIColor *selectedItemTitleColor;
//unSelected state -> Normal & Highlighted
@property (nonatomic, strong) UIColor *unSelectedItemBackgroundColor; // normal
@property (nonatomic, strong) UIColor *unSelectedItemTitleColor; // noarml
@property (nonatomic, strong) UIColor *unSelectedItemHighlightedBackgroundColor; //highlighted
@property (nonatomic, strong) UIColor *unSelectedItemHighlightedTitleColor; // highlighted
//call back
@property (nonatomic, copy) void (^segmentControlSelectedHanlder)(NSUInteger);

- (instancetype)initWithItem:(NSArray <NSString *> *)items NS_DESIGNATED_INITIALIZER;

@end
