//
//  IZSwitch.h
//  VegansMeet
//
//  Created by Сергей Навка on 9/23/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface IZSwitch : UIControl
//state
@property (nonatomic, getter=isOn) IBInspectable BOOL on;
//thumb
@property (nonatomic) IBInspectable CGFloat thumbEdgeOffset;
@property (strong, nonatomic) IBInspectable UIColor *onThumbColor;
@property (strong, nonatomic) IBInspectable UIColor *offThumbColor;
//background
@property (strong, nonatomic) IBInspectable UIColor *onBackgroundColor;
@property (strong, nonatomic) IBInspectable UIColor *offBackgroundColor;
//border line
@property (strong, nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidht;
@property (nonatomic) IBInspectable CGFloat edgeForBorderLine;

@end
