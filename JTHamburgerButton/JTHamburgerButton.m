//
//  JTHamburgerButton.m
//  JTHamburgerButton
//
//  Created by Jonathan Tribouharet
//

#import "JTHamburgerButton.h"

#define MIDDLE_SCALE_FACTOR .8

@interface JTHamburgerButton (){
    CAShapeLayer *topLayer;
    CAShapeLayer *middleLayer;
    CAShapeLayer *bottomLayer;
    
    CGRect lastBounds;
}

@end

@implementation JTHamburgerButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    self.lineColor = [UIColor whiteColor];
    self.lineHeight = 1.5;
    self.lineSpacing = 3.5;
    self.lineWidth = 24.;
    
    self.animationDuration = .3;
    
    self->_currentMode = JTHamburgerButtonModeHamburger;
    [self updateAppearance];
}

- (void)setCurrentMode:(JTHamburgerButtonMode)currentMode
{
    if(self.currentMode == currentMode){
        return;
    }
    
    self->_currentMode = currentMode;
    [self updateAppearance];
}

- (void)setCurrentModeWithAnimation:(JTHamburgerButtonMode)currentMode
{
    [self setCurrentModeWithAnimation:currentMode duration:self.animationDuration];
}

- (void)setCurrentModeWithAnimation:(JTHamburgerButtonMode)currentMode duration:(CGFloat)duration
{
    if(self.currentMode == currentMode){
        return;
    }
    
    switch (self.currentMode) {
        case JTHamburgerButtonModeHamburger:
            switch (currentMode) {
                case JTHamburgerButtonModeHamburger:
                    // Nothing
                    break;
                case JTHamburgerButtonModeArrow:
                    [self transformFromHamburgerToArrow:duration];
                    break;
                case JTHamburgerButtonModeCross:
                    [self transformFromHamburgerToCross:duration];
                    break;
            }
            break;
        case JTHamburgerButtonModeArrow:
            switch (currentMode) {
                case JTHamburgerButtonModeHamburger:
                    [self transformFromArrowToHamburger:duration];
                    break;
                case JTHamburgerButtonModeArrow:
                    // Nothing
                    break;
                case JTHamburgerButtonModeCross:
                    [self transformFromArrowToCross:duration];
                    break;
            }
            break;
        case JTHamburgerButtonModeCross:
            switch (currentMode) {
                case JTHamburgerButtonModeHamburger:
                    [self transformFromCrossToHamburger:duration];
                    break;
                case JTHamburgerButtonModeArrow:
                    [self transformFromCrossToArrow:duration];
                    break;
                case JTHamburgerButtonModeCross:
                    // Nothing
                    break;
            }
            break;
    }
    
    // Must be set after for transformModeHamburgerWithAnimation
    self->_currentMode = currentMode;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if(!CGRectEqualToRect(lastBounds, self.bounds)){
        [self updateAppearance];
    }
}

- (void)updateAppearance
{
    lastBounds = self.bounds;
    
    [topLayer removeFromSuperlayer];
    [middleLayer removeFromSuperlayer];
    [bottomLayer removeFromSuperlayer];
    
    CGFloat x = CGRectGetWidth(self.frame) / 2.;
    
    {
        CGFloat y = (CGRectGetHeight(self.frame) / 2.) - self.lineHeight - self.lineSpacing;
        topLayer = [self createLayer];
        topLayer.position = CGPointMake(x , y);
    }
    {
        CGFloat y = CGRectGetHeight(self.frame) / 2.;
        middleLayer = [self createLayer];
        middleLayer.position = CGPointMake(x , y);
    }
    {
        CGFloat y = (CGRectGetHeight(self.frame) / 2.) + self.lineHeight + self.lineSpacing;
        bottomLayer = [self createLayer];
        bottomLayer.position = CGPointMake(x , y);
    }
    
    switch (self.currentMode) {
        case JTHamburgerButtonModeHamburger:
            [self transformModeHamburger];
            break;
        case JTHamburgerButtonModeArrow:
            [self transformModeArrow];
            break;
        case JTHamburgerButtonModeCross:
            [self transformModeCross];
            break;
    }
}

- (CAShapeLayer *)createLayer
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.lineWidth, 0)];
    
    layer.path = path.CGPath;
    layer.lineWidth = self.lineHeight;
    layer.strokeColor = self.lineColor.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    
    [self.layer addSublayer:layer];
    
    return layer;
}

#pragma mark - Transform without animation

- (void)transformModeHamburger
{
    topLayer.transform = CATransform3DIdentity;
    middleLayer.transform = CATransform3DIdentity;
    bottomLayer.transform = CATransform3DIdentity;
}

- (void)transformModeArrow
{
    {
        CGFloat angle = M_PI + M_PI_4;
        CGFloat scaleFactor = .5;
        
        CATransform3D t = CATransform3DIdentity;
        
        // Translate to bottom position
        CGFloat translateX = 0;
        CGFloat translateY = (middleLayer.position.y + (self.lineWidth / 2.)) - topLayer.position.y;
        
        // Translate for 45 degres rotation
        translateX += (1. - fabs(cosf(angle))) * self.lineWidth / 2. * -1. * (1. / scaleFactor);
        translateY += (1. - fabs(sinf(angle))) * self.lineWidth / 2. * -1. * (1. / scaleFactor);
        
        // Hack
        translateX -= 1.;
        translateY -= 1.;
        
        t = CATransform3DTranslate(t, translateX, translateY, 0);
        t = CATransform3DRotate(t, angle, 0, 0, 1);
        t = CATransform3DScale(t, scaleFactor, 1., 1.);
        
        topLayer.transform = t;
    }
    
    {
        CGFloat scaleFactor = MIDDLE_SCALE_FACTOR;
        
        CATransform3D t = CATransform3DIdentity;
        
        t = CATransform3DRotate(t, M_PI, 0, 0, 1);
        t = CATransform3DScale(t, scaleFactor, 1., 1.);
        t = CATransform3DTranslate(t, (1. - scaleFactor) * self.lineWidth / 2., 0, 0);
        
        middleLayer.transform = t;
    }
    
    {
        CGFloat angle = M_PI - M_PI_4;
        CGFloat scaleFactor = .5;
        
        CATransform3D t = CATransform3DIdentity;
        
        // Translate to bottom position
        CGFloat translateX = 0;
        CGFloat translateY = (middleLayer.position.y - (self.lineWidth / 2.)) - bottomLayer.position.y;
        
        // Translate for 45 degres rotation
        translateX += (1. - fabs(cosf(angle))) * self.lineWidth / 2. * -1. * (1. / scaleFactor);
        translateY += (1. - fabs(sinf(angle))) * self.lineWidth / 2. * (1. / scaleFactor);
        
        // Hack
        translateX -= 1.;
        translateY += 1.;
        
        t = CATransform3DTranslate(t, translateX, translateY, 0);
        t = CATransform3DRotate(t, angle, 0, 0, 1);
        t = CATransform3DScale(t, scaleFactor, 1., 1.);
        
        bottomLayer.transform = t;
    }
}

- (void)transformModeCross
{
    {
        CGFloat angle = M_PI_4;
        
        CGFloat translateY = middleLayer.position.y - topLayer.position.y;
        
        CATransform3D t = CATransform3DIdentity;
        t = CATransform3DTranslate(t, 0, translateY, 0);
        t = CATransform3DRotate(t, angle, 0, 0, 1);
        
        topLayer.transform = t;
    }
    
    {
        CATransform3D t = CATransform3DIdentity;
        t = CATransform3DScale(t, 0, 1., 1.);
        
        middleLayer.transform = t;
    }
    
    {
        CGFloat angle = - M_PI_4;
        
        CGFloat translateY = middleLayer.position.y - bottomLayer.position.y;
        
        CATransform3D t = CATransform3DIdentity;
        t = CATransform3DTranslate(t, 0, translateY, 0);
        t = CATransform3DRotate(t, angle, 0, 0, 1);
        
        bottomLayer.transform = t;
    }
}

#pragma mark - Transform with animation

- (void)transformFromHamburgerToArrow:(CGFloat)duration
{
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self hamburgerToArrowValuesTopLayer];
        [topLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self hamburgerToArrowValuesMiddleLayer];
        [middleLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self hamburgerToArrowValuesBottomLayer];
        [bottomLayer addAnimation:animation forKey:@"transform"];
    }
}

- (void)transformFromHamburgerToCross:(CGFloat)duration
{
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self hamburgerToCrossValuesTopLayer];
        [topLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self hamburgerToCrossValuesMiddleLayer];
        [middleLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self hamburgerToCrossValuesBottomLayer];
        [bottomLayer addAnimation:animation forKey:@"transform"];
    }
}

- (void)transformFromArrowToHamburger:(CGFloat)duration
{
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self reverseValues:[self hamburgerToArrowValuesTopLayer]];
        [topLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self reverseValues:[self hamburgerToArrowValuesMiddleLayer]];
        [middleLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self reverseValues:[self hamburgerToArrowValuesBottomLayer]];
        [bottomLayer addAnimation:animation forKey:@"transform"];
    }
}

- (void)transformFromArrowToCross:(CGFloat)duration
{
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self arrowToCrossValuesTopLayer];
        [topLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self arrowToCrossValuesMiddleLayer];
        [middleLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self arrowToCrossValuesBottomLayer];
        [bottomLayer addAnimation:animation forKey:@"transform"];
    }
}

- (void)transformFromCrossToHamburger:(CGFloat)duration
{
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self reverseValues:[self hamburgerToCrossValuesTopLayer]];
        [topLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self reverseValues:[self hamburgerToCrossValuesMiddleLayer]];
        [middleLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self reverseValues:[self hamburgerToCrossValuesBottomLayer]];
        [bottomLayer addAnimation:animation forKey:@"transform"];
    }
}

- (void)transformFromCrossToArrow:(CGFloat)duration
{
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self reverseValues:[self arrowToCrossValuesTopLayer]];
        [topLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self reverseValues:[self arrowToCrossValuesMiddleLayer]];
        [middleLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self reverseValues:[self arrowToCrossValuesBottomLayer]];
        [bottomLayer addAnimation:animation forKey:@"transform"];
    }
}

#pragma mark -

- (CAKeyframeAnimation *)createKeyFrameAnimation:(CGFloat)duration
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO; // Keep changes
    animation.fillMode = kCAFillModeForwards; // Keep changes
    
    return animation;
}

- (NSArray *)reverseValues:(NSArray *)values
{
    NSMutableArray *newValues = [values mutableCopy];
    newValues = [[[newValues reverseObjectEnumerator] allObjects] mutableCopy];
    
    return newValues;
}

#pragma mark - Hamburger / Arrow

- (NSArray *)hamburgerToArrowValuesTopLayer
{
    CGFloat NUMBER_VALUES = 4;
    
    CGFloat startScaleFactor = 1.;
    CGFloat endScaleFactor = .5;
    
    CGFloat endAngle = M_PI + M_PI_4;
    
    NSMutableArray *values = [NSMutableArray new];
    
    for(int i = 0; i < NUMBER_VALUES; ++i){
        CGFloat angle = endAngle / (NUMBER_VALUES - 1.) * i;
        CGFloat scaleFactor = startScaleFactor + (endScaleFactor - startScaleFactor) * i / (NUMBER_VALUES - 1.);
        
        CATransform3D t = CATransform3DIdentity;
        
        // Translate to bottom position
        CGFloat translateX = 0;
        CGFloat translateY = (middleLayer.position.y + (self.lineWidth / 2.)) - topLayer.position.y;
        
        // Translate for 45 degres rotation
        translateX += (1. - fabs(cosf(endAngle))) * self.lineWidth / 2. * -1. * (1. / endScaleFactor);
        translateY += (1. - fabs(sinf(endAngle))) * self.lineWidth / 2. * -1. * (1. / endScaleFactor);
        
        // Hack
        translateX -= 1.;
        translateY -= 1.;
        
        translateX *= i / (NUMBER_VALUES - 1.);
        translateY *= i / (NUMBER_VALUES - 1.);
        
        // Hack avoiding topLayer cross middleLayer
        if(i == 1){
            translateX += self.lineWidth * 1 / 4;
            translateY += self.lineWidth * 1 / 8;
        }
        else if(i == 2){
            translateX += self.lineWidth * 1 / 4;
            translateY += self.lineWidth * 1 / 8;
        }
        
        t = CATransform3DTranslate(t, translateX, translateY, 0);
        t = CATransform3DRotate(t, angle, 0, 0, 1);
        t = CATransform3DScale(t, scaleFactor, 1., 1.);
        
        NSValue *value = [NSValue valueWithCATransform3D:t];
        [values addObject:value];
    }
    
    return values;
}

- (NSArray *)hamburgerToArrowValuesMiddleLayer
{
    CGFloat NUMBER_VALUES = 4;
    
    CGFloat startScaleFactor = 1.;
    CGFloat endScaleFactor = MIDDLE_SCALE_FACTOR;
    
    CGFloat endAngle = M_PI;
    
    NSMutableArray *values = [NSMutableArray new];
    
    for(int i = 0; i < NUMBER_VALUES; ++i){
        CGFloat angle = endAngle / (NUMBER_VALUES - 1.) * i;
        CGFloat scaleFactor = startScaleFactor + (endScaleFactor - startScaleFactor) * i / (NUMBER_VALUES - 1.);
        
        CATransform3D t = CATransform3DIdentity;
        
        t = CATransform3DRotate(t, angle, 0, 0, 1);
        t = CATransform3DScale(t, scaleFactor, 1., 1.);
        t = CATransform3DTranslate(t, (1. - scaleFactor) * self.lineWidth / 2., 0, 0);
        
        NSValue *value = [NSValue valueWithCATransform3D:t];
        [values addObject:value];
    }
    
    return values;
}

- (NSArray *)hamburgerToArrowValuesBottomLayer
{
    CGFloat NUMBER_VALUES = 4;
    
    CGFloat startScaleFactor = 1.;
    CGFloat endScaleFactor = .5;
    
    CGFloat endAngle = M_PI - M_PI_4;
    
    NSMutableArray *values = [NSMutableArray new];
    
    for(int i = 0; i < NUMBER_VALUES; ++i){
        CGFloat angle = endAngle / (NUMBER_VALUES - 1.) * i;
        CGFloat scaleFactor = startScaleFactor + (endScaleFactor - startScaleFactor) * i / (NUMBER_VALUES - 1.);
        
        CATransform3D t = CATransform3DIdentity;
        
        // Translate to bottom position
        CGFloat translateX = 0;
        CGFloat translateY = (middleLayer.position.y - (self.lineWidth / 2.)) - bottomLayer.position.y;
        
        // Translate for 45 degres rotation
        translateX += (1. - fabs(cosf(endAngle))) * self.lineWidth / 2. * -1. * (1. / endScaleFactor);
        translateY += (1. - fabs(sinf(endAngle))) * self.lineWidth / 2. * (1. / endScaleFactor);
        
        // Hack
        translateX -= 1.;
        translateY += 1.;
        
        translateX *= i / (NUMBER_VALUES - 1.);
        translateY *= i / (NUMBER_VALUES - 1.);
        
        t = CATransform3DTranslate(t, translateX, translateY, 0);
        t = CATransform3DRotate(t, angle, 0, 0, 1);
        t = CATransform3DScale(t, scaleFactor, 1., 1.);
        
        NSValue *value = [NSValue valueWithCATransform3D:t];
        [values addObject:value];
    }
    
    return values;
}

#pragma mark - Hamburger / Cross

- (NSArray *)hamburgerToCrossValuesTopLayer
{
    CGFloat NUMBER_VALUES = 4;
    
    CGFloat endAngle = M_PI_4;
    
    NSMutableArray *values = [NSMutableArray new];
    
    for(int i = 0; i < NUMBER_VALUES; ++i){
        CGFloat angle = endAngle / (NUMBER_VALUES - 1.) * i;
        
        CATransform3D t = CATransform3DIdentity;
        
        CGFloat translateY = middleLayer.position.y - topLayer.position.y;
        translateY *= i / (NUMBER_VALUES - 1.);
        
        t = CATransform3DTranslate(t, 0, translateY, 0);
        t = CATransform3DRotate(t, angle, 0, 0, 1);
        
        NSValue *value = [NSValue valueWithCATransform3D:t];
        [values addObject:value];
    }
    
    return values;
}

- (NSArray *)hamburgerToCrossValuesMiddleLayer
{
    CGFloat NUMBER_VALUES = 4;
    
    CGFloat startScaleFactor = 1.;
    CGFloat endScaleFactor = .0;
    
    NSMutableArray *values = [NSMutableArray new];
    
    for(int i = 0; i < NUMBER_VALUES; ++i){
        CGFloat scaleFactor = startScaleFactor + (endScaleFactor - startScaleFactor) * i / (NUMBER_VALUES - 1.);
        
        CATransform3D t = CATransform3DIdentity;
        t = CATransform3DScale(t, scaleFactor, 1., 1.);
        
        NSValue *value = [NSValue valueWithCATransform3D:t];
        [values addObject:value];
    }
    
    return values;
}

- (NSArray *)hamburgerToCrossValuesBottomLayer
{
    CGFloat NUMBER_VALUES = 4;
    
    CGFloat endAngle = - M_PI_4;
    
    NSMutableArray *values = [NSMutableArray new];
    
    for(int i = 0; i < NUMBER_VALUES; ++i){
        CGFloat angle = endAngle / (NUMBER_VALUES - 1.) * i;
        
        CATransform3D t = CATransform3DIdentity;
        
        CGFloat translateY = middleLayer.position.y - bottomLayer.position.y;
        translateY *= i / (NUMBER_VALUES - 1.);
        
        t = CATransform3DTranslate(t, 0, translateY, 0);
        t = CATransform3DRotate(t, angle, 0, 0, 1);
        
        NSValue *value = [NSValue valueWithCATransform3D:t];
        [values addObject:value];
    }
    
    return values;
}

#pragma mark - Arrow / Cross

- (NSArray *)arrowToCrossValuesTopLayer
{
    CGFloat NUMBER_VALUES = 4;
    
    CGFloat startScaleFactor = .5;
    CGFloat endScaleFactor = 1.;
    
    CGFloat startTranslateX = 0;
    CGFloat startTranslateY = 0;
    CGFloat endTranslateX = 0;
    CGFloat endTranslateY = middleLayer.position.y - topLayer.position.y;
    
    CGFloat angle = M_PI_4;
    
    {
        // Final position
        startTranslateX = self.lineWidth * (1. - MIDDLE_SCALE_FACTOR) / 2.;
        startTranslateY = middleLayer.position.y - topLayer.position.y;
        
        // cancel scaleFactor
        startTranslateX += (self.lineWidth * (1. - startScaleFactor)) / 2. * -1.;
        
        // cancel rotation
        startTranslateX += fabs(cosf(angle)) * (self.lineWidth * startScaleFactor) / 2. * -1.;
        startTranslateY += fabs(sinf(angle)) * (self.lineWidth * startScaleFactor) / 2.;
        
        // Hack
        startTranslateX += 2.;
    }
    
    NSMutableArray *values = [NSMutableArray new];
    
    for(int i = 0; i < NUMBER_VALUES; ++i){
        CGFloat scaleFactor = startScaleFactor + (endScaleFactor - startScaleFactor) * i / (NUMBER_VALUES - 1.);
        CGFloat translateX = startTranslateX + (endTranslateX - startTranslateX) * i / (NUMBER_VALUES - 1.);
        CGFloat translateY = startTranslateY + (endTranslateY - startTranslateY) * i / (NUMBER_VALUES - 1.);
        
        CATransform3D t = CATransform3DIdentity;
        
        t = CATransform3DTranslate(t, translateX, translateY, 0);
        t = CATransform3DRotate(t, angle, 0, 0, 1);
        t = CATransform3DScale(t, scaleFactor, 1., 1.);
        
        NSValue *value = [NSValue valueWithCATransform3D:t];
        [values addObject:value];
    }
    
    return values;
}

- (NSArray *)arrowToCrossValuesMiddleLayer
{
    CGFloat NUMBER_VALUES = 4;
    
    CGFloat startScaleFactor = MIDDLE_SCALE_FACTOR;
    CGFloat endScaleFactor = .0;
    
    NSMutableArray *values = [NSMutableArray new];
    
    for(int i = 0; i < NUMBER_VALUES; ++i){
        CGFloat scaleFactor = startScaleFactor + (endScaleFactor - startScaleFactor) * i / (NUMBER_VALUES - 1.);
        
        CATransform3D t = CATransform3DIdentity;
        t = CATransform3DScale(t, scaleFactor, 1., 1.);
        
        NSValue *value = [NSValue valueWithCATransform3D:t];
        [values addObject:value];
    }
    
    return values;
}

- (NSArray *)arrowToCrossValuesBottomLayer
{
    CGFloat NUMBER_VALUES = 4;
    
    CGFloat startScaleFactor = .5;
    CGFloat endScaleFactor = 1.;
    
    CGFloat startTranslateX = 0;
    CGFloat startTranslateY = 0;
    CGFloat endTranslateX = 0;
    CGFloat endTranslateY = middleLayer.position.y - bottomLayer.position.y;
    
    CGFloat angle = - M_PI_4;
    
    {
        // Final position
        startTranslateX = self.lineWidth * (1. - MIDDLE_SCALE_FACTOR) / 2.;
        startTranslateY = - (bottomLayer.position.y - middleLayer.position.y);
        
        // cancel scaleFactor
        startTranslateX += (self.lineWidth * (1. - startScaleFactor)) / 2. * -1.;
        
        // cancel rotation
        startTranslateX += fabs(cosf(angle)) * (self.lineWidth * startScaleFactor) / 2. * -1.;
        startTranslateY += fabs(sinf(angle)) * (self.lineWidth * startScaleFactor) / 2. * -1.;
        
        // Hack
        startTranslateX += 2.;
    }
    
    NSMutableArray *values = [NSMutableArray new];
    
    for(int i = 0; i < NUMBER_VALUES; ++i){
        CGFloat scaleFactor = startScaleFactor + (endScaleFactor - startScaleFactor) * i / (NUMBER_VALUES - 1.);
        CGFloat translateX = startTranslateX + (endTranslateX - startTranslateX) * i / (NUMBER_VALUES - 1.);
        CGFloat translateY = startTranslateY + (endTranslateY - startTranslateY) * i / (NUMBER_VALUES - 1.);
        
        CATransform3D t = CATransform3DIdentity;
        
        t = CATransform3DTranslate(t, translateX, translateY, 0);
        t = CATransform3DRotate(t, angle, 0, 0, 1);
        t = CATransform3DScale(t, scaleFactor, 1., 1.);
        
        NSValue *value = [NSValue valueWithCATransform3D:t];
        [values addObject:value];
    }
    
    return values;
}

@end
