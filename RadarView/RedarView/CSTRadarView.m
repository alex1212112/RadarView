//
//  CSTRadarView.m
//  CoasterNevermore
//
//  Created by Ren Guohua on 15/6/24.
//  Copyright (c) 2015年 Ren guohua. All rights reserved.
//

#import "CSTRadarView.h"

@interface CSTRadarLayer : CALayer

@property (nonatomic, assign) NSInteger pulseCount;
@property (nonatomic, strong) UIColor *pulseColor;
@property (nonatomic, assign) CGFloat pulseWidth;
@property (nonatomic, strong) NSArray *shapeLayers;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign, getter=isAnimated) BOOL animated;

@end

@implementation CSTRadarLayer
@synthesize pulseWidth = _pulseWidth;
@synthesize pulseColor = _pulseColor;
@synthesize pulseCount = _pulseCount;

#pragma mark - Life cycle
- (instancetype)init{

    if (self = [super init]) {
        
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    
    if (self.animated) {
        
        [self stopAnimation];
        [self.shapeLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperlayer];
        }];
        
        self.shapeLayers = [self creatShapelayersWithCount:self.pulseCount];
        [self.shapeLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            [self insertSublayer:obj atIndex:0];
        }];
        [self startAnimation];
    }
    else{
        
        [self.shapeLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperlayer];
        }];
        self.shapeLayers = [self creatShapelayersWithCount:self.pulseCount];
        [self.shapeLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            [self insertSublayer:obj atIndex:0];
        }];
    }
}

#pragma mark - Public method

- (void)startAnimation{

    [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL *stop) {
       
        obj.hidden = NO;
        CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + idx * self.animationDuration / self.pulseCount;
        animationGroup.duration = self.animationDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        animationGroup.timeOffset = 0;
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @(0);
        scaleAnimation.toValue = @(1.0);
        
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@(1),@(0.7),@(0)];
        opacityAnimation.keyTimes = @[@(0),@(0.5),@(1)];
        
        animationGroup.animations = @[scaleAnimation,opacityAnimation];
        
        [obj addAnimation:animationGroup forKey:@"pulsing"];
    }];
    
    self.animated = YES;
}

- (void)stopAnimation{

    [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL *stop) {
    
        [obj removeAnimationForKey:@"pulsing"];
        obj.hidden = YES;
    }];
    self.animated = NO;
}

#pragma mark - Private method

- (NSArray *)creatShapelayersWithCount:(NSInteger)count{

    NSMutableArray *mutableArray = [NSMutableArray array];
    CGRect rect = self.bounds;
    CGPoint center = CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) / 2);
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)) / 2.0f;
    
    for (NSInteger currentCout = 0; currentCout < count; currentCout ++) {
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.frame = rect;
        CGMutablePathRef mutablePath = CGPathCreateMutable();
        CGPathAddArc(mutablePath, NULL, center.x, center.y, radius, (float)(2.0f * M_PI), 0.0f, YES);
        layer.path = mutablePath;
        layer.lineWidth = self.pulseWidth;
        layer.strokeColor = self.pulseColor.CGColor;
        layer.fillColor = nil;
        layer.hidden = YES;
        [mutableArray addObject:layer];
        CGPathRelease(mutablePath);
    }
    return  [NSArray arrayWithArray:mutableArray];
}

#pragma mark - Setters and getters

- (NSArray *)shapeLayers{

    if (!_shapeLayers) {
        
        _shapeLayers = [self creatShapelayersWithCount:self.pulseCount];
    }
    
    return _shapeLayers;
}



- (void)setPulseCount:(NSInteger)pulseCount{

    NSAssert(pulseCount > 0, @"pulseCount must >0");
  
    if (_pulseCount != pulseCount) {
        _pulseCount = pulseCount;
     
        if (self.animated) {
            
            [self stopAnimation];
            [self.shapeLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj removeFromSuperlayer];
            }];
            
            self.shapeLayers = [self creatShapelayersWithCount:_pulseCount];
            [self.shapeLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [self addSublayer:obj];
            }];
            [self startAnimation];
        }
        else{
        
            [self.shapeLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj removeFromSuperlayer];
            }];
            
            self.shapeLayers = [self creatShapelayersWithCount:_pulseCount];
            [self.shapeLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [self addSublayer:obj];
            }];
        }
    }
}


- (NSInteger)pulseCount{

    if (_pulseCount == 0) {
        
        _pulseCount = 6;
    }
    
    return _pulseCount;
}


- (void)setPulseColor:(UIColor *)pulseColor{

    if (_pulseColor != pulseColor) {
        
        if (self.animated) {
            [self stopAnimation];
            [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL *stop) {
                
                obj.strokeColor = pulseColor.CGColor;
            }];
            [self startAnimation];
        }
        else
        {
            [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL *stop) {
                
                obj.strokeColor = pulseColor.CGColor;
            }];
        }
        _pulseColor = pulseColor;
    }
}

- (UIColor *)pulseColor{
    
    if (!_pulseColor) {
        
        _pulseColor = [UIColor blackColor];
    }
    
    return _pulseColor;
}


- (void)setPulseWidth:(CGFloat)pulseWidth{
    
    NSAssert(pulseWidth > 0, @"pulseCount must >0");
    
    if (_pulseWidth != pulseWidth) {
        
        if (self.animated) {
            [self stopAnimation];
            [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL *stop) {
                
                obj.lineWidth = pulseWidth;
            }];
            [self startAnimation];
        }else{
            [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL *stop) {
                
                obj.lineWidth = pulseWidth;
            }];
        }
     
        _pulseWidth = pulseWidth;
    }
}

- (CGFloat)pulseWidth{
    
    if (_pulseWidth == 0) {
        
        _pulseWidth = 0.5;
    }
    
    return _pulseWidth;
}

- (CGFloat)animationDuration{
    if (_animationDuration == 0) {
        
        _animationDuration = 4;
    }
    
    return _animationDuration;

}
@end

@interface CSTRadarView()

@property (nonatomic,assign) BOOL animatedWhenEnterBackground;

@end

@implementation CSTRadarView


#pragma mark - Life cycle

+ (void)initialize{

    if (self == [CSTRadarView class]) {
    
    
    }
}
+ (Class)layerClass{
    
    return [CSTRadarLayer class];
}

- (CSTRadarLayer *)radarLayer{
    
    return (CSTRadarLayer *)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        self.radarLayer.pulseColor = [UIColor whiteColor];
        self.radarLayer.pulseWidth = 2.0;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        self.radarLayer.pulseColor = [UIColor whiteColor];
        self.radarLayer.pulseWidth = 2.0;
    }
    return self;
}


- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}


#pragma mark - Public method

- (void)startAnimation{

    [(CSTRadarLayer *)(self.layer) startAnimation];
    self.animated = YES;
}

- (void)stopAnimation{

    [(CSTRadarLayer *)(self.layer) stopAnimation];
    self.animated = NO;
}


#pragma mark Event response

- (void)viewDidEnterBackground:(id)sender{
    
    if (self.animated) {
     
        [self stopAnimation];
        self.animatedWhenEnterBackground = YES;
    }else{
    
        self.animatedWhenEnterBackground = NO;
    }
}

- (void)viewWillEnterForeground:(id)sender{

    if (self.animatedWhenEnterBackground) {
     
        [self startAnimation];
        self.animatedWhenEnterBackground = NO;
    }
}

#pragma mark - Setters and getters

- (void)setColor:(UIColor *)color{

    if (_color != color) {
        
        ((CSTRadarLayer *)(self.layer)).pulseColor = color;
        _color = color;
    }
}


- (void)setWidth:(CGFloat)width{

    if (_width != width) {
        
        ((CSTRadarLayer *)(self.layer)).pulseWidth = width;
        _width = width;
    }
    
}

@end