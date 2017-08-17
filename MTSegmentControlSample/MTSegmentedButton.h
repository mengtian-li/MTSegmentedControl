//
//  MTSegmentedButton.h
//  MTSegmentControlSample
//
//  Created by LiMengtian on 16/08/2017.
//  Copyright © 2017 LiMengtian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MTSegmentControlButtonType) {
    MTSegmentControlButtonTypeSelected = 0, // selected
    MTSegmentControlButtonTypeUnSelected, // unselected normal
    MTSegmentControlButtonTypeHighlighted, // unselected highlighted
};

@class MTSegmentedButton;
@protocol MTSegmentedButtonDelegate <NSObject>

- (UIImage *)selectedImage;
- (UIColor *)selectedTitleColor;

- (UIImage *)unSelectedNormalImage;
- (UIColor *)unSelectedNormalTitleColor;
- (UIImage *)unSelectedHighlightedImage;
- (UIColor *)unSelectedHighlightedTitleColor;

- (void)itemSelected:(MTSegmentedButton *)button;

@end

@interface MTSegmentedButton : UIButton

@property (nonatomic) MTSegmentControlButtonType type;
@property (nonatomic, weak) id<MTSegmentedButtonDelegate> delegate;

@end
