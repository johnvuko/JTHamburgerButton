//
//  JTHamburgerButton.h
//  JTHamburgerButton
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JTHamburgerButtonMode) {
    JTHamburgerButtonModeHamburger,
    JTHamburgerButtonModeArrow,
    JTHamburgerButtonModeCross
};

@interface JTHamburgerButton : UIButton

@property (nonatomic) CGFloat lineHeight;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) UIColor *lineColor;

@property (nonatomic) CGFloat animationDuration;

@property (nonatomic) JTHamburgerButtonMode currentMode;

- (void)setCurrentModeWithAnimation:(JTHamburgerButtonMode)currentMode;
- (void)setCurrentModeWithAnimation:(JTHamburgerButtonMode)currentMode duration:(CGFloat)duration;

- (void)updateAppearance;

@end