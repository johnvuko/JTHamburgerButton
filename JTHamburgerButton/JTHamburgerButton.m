//
//  JTHamburgerButton.m
//  JTHamburgerButton
//
//  Created by Jonathan Tribouharet
//

#import "JTHamburgerButton.h"

@interface JTHamburgerButton (){
    CAShapeLayer *topLayer;
    CAShapeLayer *middleLayer;
    CAShapeLayer *bottomLayer;
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
    
    switch (currentMode) {
        case JTHamburgerButtonModeHamburger:
            [self transformModeHamburgerWithAnimation:duration];
            break;
        case JTHamburgerButtonModeArrow:
            [self transformModeArrowWithAnimation:duration];
            break;
        case JTHamburgerButtonModeCross:
            [self transformModeCrossWithAnimation:duration];
            break;
    }
    
    // Must be set after for transformModeHamburgerWithAnimation
    self->_currentMode = currentMode;
}

- (void)updateAppearance
{
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
        CGFloat translateY = (middleLayer.position.y + (self.lineWidth / 2.)) - topLayer.position.y;
        CGFloat translateX = 0;
        
        // Translate for 45 degres rotation
        translateY += (1. - fabs(sinf(angle))) * self.lineWidth / 2. * -1. * (1. / scaleFactor);
        translateX += (1. - fabs(cosf(angle))) * self.lineWidth / 2. * -1. * (1. / scaleFactor);
        
        // Hack
        translateY -= 1.;
        translateX -= 1.;
        
        t = CATransform3DTranslate(t, translateX, translateY, 0);
        t = CATransform3DRotate(t, angle, 0, 0, 1);
        t = CATransform3DScale(t, scaleFactor, 1., 1.);
        
        topLayer.transform = t;
    }
    
    {
        CGFloat scaleFactor = .8;
        
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
        CGFloat translateY = (middleLayer.position.y - (self.lineWidth / 2.)) - bottomLayer.position.y;
        CGFloat translateX = 0;
        
        // Translate for 45 degres rotation
        translateY += (1. - fabs(sinf(angle))) * self.lineWidth / 2. * (1. / scaleFactor);
        translateX += (1. - fabs(cosf(angle))) * self.lineWidth / 2. * -1. * (1. / scaleFactor);
        
        // Hack
        translateY += 1.;
        translateX -= 1.;
        
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

- (void)transformModeHamburgerWithAnimation:(CGFloat)duration
{
    if(self.currentMode == JTHamburgerButtonModeArrow){
        {
            CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
            animation.values = [self reverseValues:[self arrowValuesTopLayer]];
            [topLayer addAnimation:animation forKey:@"transform"];
        }
        
        {
            CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
            animation.values = [self reverseValues:[self arrowValuesMiddleLayer]];
            [middleLayer addAnimation:animation forKey:@"transform"];
        }
        
        {
            CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
            animation.values = [self reverseValues:[self arrowValuesBottomLayer]];
            [bottomLayer addAnimation:animation forKey:@"transform"];
        }
    }
    else{
        {
            CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
            animation.values = [self reverseValues:[self crossValuesTopLayer]];
            [topLayer addAnimation:animation forKey:@"transform"];
        }
        
        {
            CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
            animation.values = [self reverseValues:[self crossValuesMiddleLayer]];
            [middleLayer addAnimation:animation forKey:@"transform"];
        }
        
        {
            CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
            animation.values = [self reverseValues:[self crossValuesBottomLayer]];
            [bottomLayer addAnimation:animation forKey:@"transform"];
        }
    }
}

- (void)transformModeArrowWithAnimation:(CGFloat)duration
{
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self arrowValuesTopLayer];
        [topLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self arrowValuesMiddleLayer];
        [middleLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self arrowValuesBottomLayer];
        [bottomLayer addAnimation:animation forKey:@"transform"];
    }
}

- (void)transformModeCrossWithAnimation:(CGFloat)duration
{
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self crossValuesTopLayer];
        [topLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self crossValuesMiddleLayer];
        [middleLayer addAnimation:animation forKey:@"transform"];
    }
    
    {
        CAKeyframeAnimation *animation = [self createKeyFrameAnimation:duration];
        animation.values = [self crossValuesBottomLayer];
        [bottomLayer addAnimation:animation forKey:@"transform"];
    }
}

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
    
    [newValues removeObjectAtIndex:0];
    newValues = [[[newValues reverseObjectEnumerator] allObjects] mutableCopy];
    [newValues addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    
    return newValues;
}

#pragma mark - Mode Arrow

- (NSArray *)arrowValuesTopLayer
{
    CGFloat endAngle = M_PI + M_PI_4;
    CGFloat endScaleFactor = .5;
    
    CGFloat NUMBER_VALUES = 4;
    
    NSMutableArray *values = [NSMutableArray new];
    
    for(int i = 0; i < NUMBER_VALUES; ++i){
        CGFloat angle = endAngle / (NUMBER_VALUES - 1.) * i;
        CGFloat scaleFactor = 1. - (1. - endScaleFactor) * i / (NUMBER_VALUES - 1.);
        
        CATransform3D t = CATransform3DIdentity;
        
        // Translate to bottom position
        CGFloat translateY = (middleLayer.position.y + (self.lineWidth / 2.)) - topLayer.position.y;
        CGFloat translateX = 0;
        
        // Translate for 45 degres rotation
        translateY += (1. - fabs(sinf(endAngle))) * self.lineWidth / 2. * -1. * (1. / endScaleFactor);
        translateX += (1. - fabs(cosf(endAngle))) * self.lineWidth / 2. * -1. * (1. / endScaleFactor);
        
        // Hack
        translateY -= 1.;
        translateX -= 1.;
        
        translateY *= i / (NUMBER_VALUES - 1.);
        translateX *= i / (NUMBER_VALUES - 1.);
        
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

- (NSArray *)arrowValuesMiddleLayer
{
    CGFloat endAngle = M_PI;
    CGFloat endScaleFactor = .8;
    
    CGFloat NUMBER_VALUES = 4;
    
    NSMutableArray *values = [NSMutableArray new];
    
    for(int i = 0; i < NUMBER_VALUES; ++i){
        CGFloat angle = endAngle / (NUMBER_VALUES - 1.) * i;
        CGFloat scaleFactor = 1. - (1. - endScaleFactor) * i / (NUMBER_VALUES - 1.);
        
        CATransform3D t = CATransform3DIdentity;
        
        t = CATransform3DRotate(t, angle, 0, 0, 1);
        t = CATransform3DScale(t, scaleFactor, 1., 1.);
        t = CATransform3DTranslate(t, (1. - scaleFactor) * self.lineWidth / 2., 0, 0);
        
        NSValue *value = [NSValue valueWithCATransform3D:t];
        [values addObject:value];
    }
    
    return values;
}

- (NSArray *)arrowValuesBottomLayer
{
    CGFloat endAngle = M_PI - M_PI_4;
    CGFloat endScaleFactor = .5;
    
    CGFloat NUMBER_VALUES = 4;
    
    NSMutableArray *values = [NSMutableArray new];
        
    for(int i = 0; i < NUMBER_VALUES; ++i){
        CGFloat angle = endAngle / (NUMBER_VALUES - 1.) * i;
        CGFloat scaleFactor = 1. - (1. - endScaleFactor) * i / (NUMBER_VALUES - 1.);
        
        CATransform3D t = CATransform3DIdentity;
        
        // Translate to bottom position
        CGFloat translateY = (middleLayer.position.y - (self.lineWidth / 2.)) - bottomLayer.position.y;
        CGFloat translateX = 0;
        
        // Translate for 45 degres rotation
        translateY += (1. - fabs(sinf(endAngle))) * self.lineWidth / 2. * (1. / endScaleFactor);
        translateX += (1. - fabs(cosf(endAngle))) * self.lineWidth / 2. * -1. * (1. / endScaleFactor);
        
        // Hack
        translateY += 1.;
        translateX -= 1.;
        
        translateY *= i / (NUMBER_VALUES - 1.);
        translateX *= i / (NUMBER_VALUES - 1.);
        
        t = CATransform3DTranslate(t, translateX, translateY, 0);
        t = CATransform3DRotate(t, angle, 0, 0, 1);
        t = CATransform3DScale(t, scaleFactor, 1., 1.);
        
        NSValue *value = [NSValue valueWithCATransform3D:t];
        [values addObject:value];
    }
    
    return values;
}

#pragma mark - Mode Cross

- (NSArray *)crossValuesTopLayer
{
    CGFloat endAngle = M_PI_4;

    CGFloat NUMBER_VALUES = 4;
    
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

- (NSArray *)crossValuesMiddleLayer
{
    CGFloat endScaleFactor = .0;
    
    CGFloat NUMBER_VALUES = 4;
    
    NSMutableArray *values = [NSMutableArray new];
    
    for(int i = 0; i < NUMBER_VALUES; ++i){
        CGFloat scaleFactor = 1. - (1. - endScaleFactor) * i / (NUMBER_VALUES - 1.);
        
        CATransform3D t = CATransform3DIdentity;
        t = CATransform3DScale(t, scaleFactor, 1., 1.);
        
        NSValue *value = [NSValue valueWithCATransform3D:t];
        [values addObject:value];
    }
    
    return values;
}

- (NSArray *)crossValuesBottomLayer
{
    CGFloat endAngle = - M_PI_4;
    
    CGFloat NUMBER_VALUES = 4;
    
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

@end
