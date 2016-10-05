//
//  IZSwitchesCell.m
//  Example
//
//  Created by Сергей Навка on 10/5/16.
//  Copyright © 2016 Сергей. All rights reserved.
//

#import "IZSwitchesCell.h"
#import "IZSwitch+updateUI.h"

@interface IZSwitchesCell()

@property (strong, nonatomic) NSMutableArray *allSwitches;

@end

@implementation IZSwitchesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initialSetup];
    }
    return self;
}

#pragma mark - Private -

- (void)_initialSetup {
    self.allSwitches = [[NSMutableArray alloc] init];
   NSInteger countSwitches = 5;
    CGFloat additionalWidht = 0;
    for (int i = 1; i <= countSwitches; i++) {
            CGFloat widhtSwitch = [UIScreen mainScreen].bounds.size.width/countSwitches;
        if (i > 1) {  additionalWidht += widhtSwitch - 5.f/countSwitches; }
            CGFloat originX = i == 1 ? 5.f : additionalWidht;
            CGFloat originY = 4.f;
            CGRect frameSwitch = CGRectMake(originX, originY, widhtSwitch, 36.f);
            IZSwitch *customSwitch = [[IZSwitch alloc] initWithFrame:frameSwitch];
            [customSwitch updateSwitchUI];
            [self.allSwitches addObject:customSwitch];
            [self addSubview:customSwitch];
    }
}

@end
