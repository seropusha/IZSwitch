//
//  ViewController.m
//  Example
//
//  Created by Сергей Навка on 10/5/16.
//  Copyright © 2016 Сергей. All rights reserved.
//

#import "MainViewController.h"
#import "IZSwitch+updateUI.h"
#import "IZSwitch.h"

@interface MainViewController ()

@property (strong, nonatomic) IBOutletCollection(IZSwitch) NSArray *switches;

@property (nonatomic, getter=isChangeUI) BOOL changeUI;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.switches enumerateObjectsUsingBlock:^(IZSwitch *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj addTarget:self action:@selector(valueDidChange:) forControlEvents:UIControlEventValueChanged];
    }];
    [self _rightBarButtonWithText:@"ON change colors"];
}

#pragma mark - Action -

- (void)valueDidChange:(IZSwitch *)mySwitch {
    if (!self.changeUI) {
        return;
    }
    [self.switches enumerateObjectsUsingBlock:^(IZSwitch *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj updateSwitchUI];
    }];
}

#pragma mark - Private -

- (void)barButtonAction:(UIBarButtonItem *)barButton {
    self.changeUI = !self.changeUI;
    NSString *titleForBarButton = self.isChangeUI ? @"OFF change colors" : @"ON change colors";
    [self _rightBarButtonWithText:titleForBarButton];
}

- (void)_rightBarButtonWithText:(NSString *)title {
    UIBarButtonItem *righrBarButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(barButtonAction:)];
    self.navigationItem.rightBarButtonItem = righrBarButton;
}

@end
