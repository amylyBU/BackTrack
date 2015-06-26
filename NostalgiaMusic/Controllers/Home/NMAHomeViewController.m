//
//  NMAHomeViewController.m
//  NostalgiaMusic
//
//  Created by Bryan Weber on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAHomeViewController.h"
#import "NMASettingsViewController.h"

@interface NMAHomeViewController ()

@end

@implementation NMAHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (IBAction)goToSettings:(UIButton *)sender {
    [self.navigationController pushViewController:[NMASettingsViewController new] animated:YES];
}

@end
