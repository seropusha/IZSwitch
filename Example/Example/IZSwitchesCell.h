//
//  IZSwitchesCell.h
//  Example
//
//  Created by Сергей Навка on 10/5/16.
//  Copyright © 2016 Сергей. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IZSwitch.h"

@class IZSwitchesCell;

@protocol IZSwitchCellDelegate <NSObject>

- (void)switchCell:(IZSwitchesCell *)switchCell willUpdateUI:(IZSwitch *)tappedSwitch;

@end

@interface IZSwitchesCell : UITableViewCell

@property (weak, nonatomic) id<IZSwitchCellDelegate> delegate;

@end
