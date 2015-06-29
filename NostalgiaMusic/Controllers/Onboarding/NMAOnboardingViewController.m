//
//  NMAOnboardingViewController.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAOnboardingViewController.h"
#import "NMAAppSettings.h"
#import "AppDelegate.h"
#import "NMALoginViewController.h"

@interface NMAOnboardingViewController ()

@end

@implementation NMAOnboardingViewController

- (IBAction)userDidGetStarted:(UIButton *)sender {
    [self.delegate userDidSeeWelcome];
}

@end
