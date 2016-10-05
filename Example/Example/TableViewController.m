//
//  TableViewController.m
//  Example
//
//  Created by Сергей Навка on 10/5/16.
//  Copyright © 2016 Сергей. All rights reserved.
//

#import "TableViewController.h"
#import "IZSwitchesCell.h"


@interface TableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[IZSwitchesCell class] forCellReuseIdentifier:NSStringFromClass([IZSwitchesCell class])];
}

#pragma mark - <UITableViewDataSource> -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IZSwitchesCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IZSwitchesCell class])];
    return cell;
}

@end
