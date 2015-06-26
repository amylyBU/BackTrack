//
//  NMAOnboardingViewController.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAOnboardingViewController.h"
#import "AppDelegate.h"
#import "NMAAppSettings.h"

@interface NMAOnboardingViewController ()

@end

@implementation NMAOnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (IBAction)skipButtonPressed:(UIButton *)sender {
    [[NMAAppSettings sharedSettings] setUserOnboardingStatusToCompleted];
    [self.delegate userDidSkipOnboarding];
}

@end
