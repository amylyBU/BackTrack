//
//  NMAOnboardingViewController.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "AppDelegate.h"
#import "NMAOnboardingViewController.h"

@interface NMAOnboardingViewController ()

@end

@implementation NMAOnboardingViewController

- (IBAction)skipOnboarding:(UIButton *)sender {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app completedOnboarding];
}

@end
