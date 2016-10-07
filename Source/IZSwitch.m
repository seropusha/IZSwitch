//
//  IZSwitch.m
//  VegansMeet
//
//  Created by Сергей Навка on 9/23/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

#import "IZSwitch.h"

#define DebugColorMode 0

static CGFloat const IZChangeWidhtInDegrees = 0.3f;
static CGFloat const IZDefaultHeight = 32;
static CGFloat const IZDefaultWidht = 72;

@interface IZSwitch()

@property (strong, nonatomic) CALayer *backgroundLayer;
@property (strong, nonatomic) CALayer *borderLayer;
@property (strong, nonatomic) CALayer *thumbLayer;
//Internal
@property (nonatomic, getter=isFocusedState) BOOL focusedState;
@property (nonatomic, getter=isChangeStateWithPan) BOOL changeStateWithPan;

@end

@implementation IZSwitch

@synthesize on = _on;
@synthesize onThumbColor = _onThumbColor;
@synthesize offThumbColor = _offThumbColor;
@synthesize onBackgroundColor = _onBackgroundColor;
@synthesize offBackgroundColor = _offBackgroundColor;
@synthesize thumbEdgeOffset = _thumbEdgeOffset;
@synthesize borderWidht = _borderWidht;
@synthesize borderColor = _borderColor;

#pragma mark - Draw -

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
     [self _updateLayers];
}

#pragma mark - Initialization -

- (instancetype)init {
    CGRect defaultFrame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, IZDefaultWidht, IZDefaultHeight);
    self = [super initWithFrame:defaultFrame];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundLayer = [CALayer layer];
        self.borderLayer = [CALayer layer];
        self.thumbLayer = [CALayer layer];

        [self _setupUI];
        [self _addLongPressGestoreRecognizer];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundLayer = [CALayer layer];
    self.borderLayer = [CALayer layer];
    self.thumbLayer = [CALayer layer];
    
    [self _setupUI];
    [self _addLongPressGestoreRecognizer];
}

- (void)setFrame:(CGRect)frame {
    if (frame.size.width <= frame.size.height) {
        NSAssert(frame.size.width >= frame.size.height, @"IZSwitch widht must be more than height");
        [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, IZDefaultWidht, IZDefaultHeight)];
    } else {
        [super setFrame:frame];
    }
    [self setNeedsDisplay];
}

#pragma mark - Setter -

- (void)setOn:(BOOL)on {
    _on = on;
    [self setNeedsDisplay];
}

- (void)setOnThumbColor:(UIColor *)onThumbColor {
    _onThumbColor = onThumbColor;
    [self _updateColors];
}

- (void)setOffThumbColor:(UIColor *)offThumbColor {
    _offThumbColor = offThumbColor;
    [self _updateColors];
}

- (void)setOnBackgroundColor:(UIColor *)onBackgroundColor {
    _onBackgroundColor = onBackgroundColor;
}

- (void)setOffBackgroundColor:(UIColor *)offBackgroundColor {
    _offBackgroundColor = offBackgroundColor;
}

- (void)setThumbEdgeOffset:(CGFloat)thumbEdgeOffset {
    _thumbEdgeOffset = thumbEdgeOffset;
    [self setNeedsDisplay];
}

- (void)setEdgeForBorderLine:(CGFloat)edgeForBorderLine {
    _edgeForBorderLine = edgeForBorderLine;
    [self setNeedsDisplay];
}

- (void)setBorderWidht:(CGFloat)borderWidht {
    _borderWidht = borderWidht;
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self _updateColors];
}

#pragma mark - Getter -

- (UIColor *)onThumbColor {
    if (!_onThumbColor) {
        return [UIColor greenColor];
    }
    return  _onThumbColor;
}

- (UIColor *)offThumbColor {
    if (!_offThumbColor) {
        return [UIColor grayColor];
    }
    return _offThumbColor;
}

- (UIColor *)onBackgroundColor {
    if (!_onBackgroundColor) {
        return [UIColor grayColor];
    }
    return _onBackgroundColor;
}

- (UIColor *)offBackgroundColor {
    if (!_offBackgroundColor) {
        return [UIColor lightGrayColor];
    }
    return _offBackgroundColor;
}

- (UIColor *)borderColor {
    if (!_borderColor) {
        return [UIColor grayColor];
    }
    return _borderColor;
}

#pragma mark - Action -

- (void)longPressRecognizer:(UILongPressGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self _beganThumbAnimation];
            break;
        case UIGestureRecognizerStateChanged:{
            self.changeStateWithPan = YES;
            CGPoint location = [recognizer locationInView:self];
            if (location.x <= 0) {
                self.focusedState = NO;
                
                self.backgroundLayer.backgroundColor = self.offBackgroundColor.CGColor;
                self.thumbLayer.backgroundColor = self.offThumbColor.CGColor;
                
                CGRect frameForFousedOFF = self.thumbLayer.frame;
                frameForFousedOFF.origin.x = [self _thumbXNonFocusedPositionWithState:self.focusedState];
                [self _animationLayer:self.thumbLayer duration:0.25 toFrame:frameForFousedOFF];
            } else if (location.x >= self.bounds.size.width) {
                self.focusedState = YES;
                
                self.backgroundLayer.backgroundColor = self.onBackgroundColor.CGColor;
                self.thumbLayer.backgroundColor = self.onThumbColor.CGColor;
                
                CGRect frameForFousedON = self.thumbLayer.frame;
                frameForFousedON.origin.x = [self _thumbXNonFocusedPositionWithState:self.focusedState] - [self _additionalFocusWidht];
                [self _animationLayer:self.thumbLayer duration:0.25 toFrame:frameForFousedON];
            }
        }
            break;
        case  UIGestureRecognizerStateEnded: {
            if (self.changeStateWithPan) {
                self.on = self.focusedState;
            } else {
                self.on = !self.isOn;
            }
            
            self.changeStateWithPan = NO;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Private -

- (void)_setupUI {
    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:self.backgroundLayer];
    [self.layer addSublayer:self.borderLayer];
    [self.layer addSublayer:self.thumbLayer];
}

- (void)_updateLayers {
    CGPoint origin = self.bounds.origin;
    CGSize size = self.bounds.size;
    
    self.borderLayer.frame = self.bounds;
    self.borderLayer.borderWidth = self.borderWidht;
    
    CGFloat originXBacgrndLayer = origin.x + self.borderWidht + self.edgeForBorderLine;
    CGFloat originYBacgrndLayer = origin.y + self.borderWidht + self.edgeForBorderLine;
    CGFloat widhtBackgrndLayer = size.width - self.borderWidht*2 - self.edgeForBorderLine*2;
    CGFloat heightBackgrndLayer = size.height - self.borderWidht*2 - self.edgeForBorderLine*2;
    CGRect backgrandLayerFrame = CGRectMake(originXBacgrndLayer, originYBacgrndLayer, widhtBackgrndLayer, heightBackgrndLayer);
    self.backgroundLayer.frame = backgrandLayerFrame;
    
    CGFloat originX = [self _thumbXNonFocusedPositionWithState:self.isOn];
    CGFloat originY =  self.backgroundLayer.frame.origin.y + self.thumbEdgeOffset;
    self.thumbLayer.frame = CGRectMake(originX, originY, [self _thumbWidht], [self _thumbWidht]);
    
    self.backgroundLayer.cornerRadius = self.backgroundLayer.frame.size.height / 2;
    self.borderLayer.cornerRadius = self.borderLayer.frame.size.height / 2;
    self.thumbLayer.cornerRadius = self.thumbLayer.frame.size.height / 2;
    
    [self.backgroundLayer setNeedsDisplay];
    [self.borderLayer setNeedsDisplay];
    [self.thumbLayer setNeedsDisplay];
    
    [self _updateColors];
}

- (void)_addLongPressGestoreRecognizer {
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
    longPressRecognizer.numberOfTouchesRequired = 1;
    longPressRecognizer.minimumPressDuration = 0.f;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:longPressRecognizer];
}

- (void)_updateColors {
    UIColor *thumbColor = self.isOn ? self.onThumbColor : self.offThumbColor;
    UIColor *backgroundColor = self.isOn ? self.onBackgroundColor : self.offBackgroundColor;
    self.thumbLayer.backgroundColor = thumbColor.CGColor;
    self.backgroundLayer.backgroundColor = backgroundColor.CGColor;
    self.borderLayer.borderColor = self.borderColor.CGColor;
    
    self.backgroundLayer.borderColor = [UIColor clearColor].CGColor;
    self.borderLayer.backgroundColor = [UIColor clearColor].CGColor;

#if DebugColorMode
    [self _logRGBFromColor:thumbColor];
    [self _logRGBFromColor:backgroundColor];
#endif
}

- (void)_beganThumbAnimation {
    
    CGPoint origin = self.thumbLayer.frame.origin;
    CGSize size = self.thumbLayer.frame.size;

    CGFloat originX = self.isOn ? [self _thumbXNonFocusedPositionWithState:self.isOn] - [self _additionalFocusWidht] : [self _thumbXNonFocusedPositionWithState:self.isOn];
    CGFloat thumbFocusedWidht = [self _thumbWidht] + [self _additionalFocusWidht];
    CGRect frameToMove = CGRectMake(originX, origin.y, thumbFocusedWidht, size.height);
    [self _animationLayer:self.thumbLayer duration:1 toFrame:frameToMove];
}

- (void)_animationLayer:(CALayer *)layer duration:(NSTimeInterval)duration toFrame:(CGRect)frame {
    [CATransaction begin];
    [CATransaction setValue:@(duration) forKey:kCATransactionAnimationDuration];
    
    layer.frame = frame;
    
    [CATransaction commit];
}

- (CGFloat)_thumbXNonFocusedPositionWithState:(BOOL)state {
    CGFloat offStateX = self.backgroundLayer.frame.origin.x + self.thumbEdgeOffset;
    CGFloat onStateX = self.bounds.size.width - self.thumbEdgeOffset - self.borderWidht - self.edgeForBorderLine - [self _thumbWidht];
    return state ? onStateX : offStateX;
}

- (CGFloat)_thumbWidht {
    return self.backgroundLayer.bounds.size.height - self.thumbEdgeOffset * 2;
}

- (CGFloat)_additionalFocusWidht {
    return [self _thumbWidht] * IZChangeWidhtInDegrees;
}

- (CGFloat)_availableThumbWidht {
    return self.backgroundLayer.bounds.size.width - self.thumbEdgeOffset * 2;
}

#pragma mark - DEBUG -

- (void)_logRGBFromColor:(UIColor *)color {
    CGFloat red, green, blue, alpha;
    
    [color getRed: &red green: &green blue: &blue alpha: &alpha];
    
    NSLog(@"red = %f. Green = %f. Blue = %f. Alpha = %f",
          red * 255,
          green * 255,
          blue * 255,
          alpha);
}

@end
