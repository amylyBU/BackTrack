//
//  NMAOnboardingViewController.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAOnboardingViewController.h"
#import "NMAHomeViewController.h"
#import "AppDelegate.h"

@interface NMAOnboardingViewController ()

@end

@implementation NMAOnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (IBAction)skipButtonPressed:(UIButton *)sender {
    [[NMAAppSettings sharedSettings] setUserDefaultSettingForKey:@"hasOnboarded" withBool:YES];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app goToHome];
}
@end
