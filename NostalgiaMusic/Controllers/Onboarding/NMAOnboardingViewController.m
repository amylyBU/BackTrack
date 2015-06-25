//
//  NMAOnboardingViewController.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "AppDelegate.h"
#import "NMAOnboardingViewController.h"
#import "NMAAppSettings.h"
#import "NMAHomeViewController.h"

@interface NMAOnboardingViewController ()

@end

@implementation NMAOnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

// NOTE: this is the same method as in LoginViewController
- (IBAction)skipButtonPressed:(UIButton *)sender {
    [[NMAAppSettings sharedSettings] setUserDefaultSettingForKey:@"hasOnboarded" withBool:YES];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app goToHome];
}
@end
