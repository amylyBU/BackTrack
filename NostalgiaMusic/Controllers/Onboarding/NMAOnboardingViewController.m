//
//  NMAOnboardingViewController.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "AppDelegate.h"
#import "NMAOnboardingViewController.h"
#import "NMAHomeViewController.h"
#import "NMAAppSettings.h"

@interface NMAOnboardingViewController ()

@end

@implementation NMAOnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(self.hideSkip)
    {
        [self.skipButton setEnabled:NO];
        self.skipButton.hidden = YES;
    }
}

- (IBAction)fakeOnboarding:(UIButton *)sender {}

- (IBAction)skipOnboarding:(UIButton *)sender {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app completedOnboarding];
}

@end
