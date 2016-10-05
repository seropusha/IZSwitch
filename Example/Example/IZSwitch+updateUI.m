//
//  IZSwitch+updateUI.m
//  Example
//
//  Created by Сергей Навка on 10/5/16.
//  Copyright © 2016 Сергей. All rights reserved.
//

#import "IZSwitch+updateUI.h"

@implementation IZSwitch (updateUI)

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

- (void)updateSwitchUI {
    self.borderWidht = arc4random() % 4;
    self.edgeForBorderLine = arc4random() % 4;
    self.thumbEdgeOffset = arc4random() % 4;
    self.onThumbColor = [self randomColor];
    self.offThumbColor = [self randomColor];
    self.onBackgroundColor = [self randomColor];
    self.offBackgroundColor = [self randomColor];
}

@end
