//
//  NMAOnboardingEndViewController.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/29/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAOnboardingEndViewController.h"

@interface NMAOnboardingEndViewController ()

@end

@implementation NMAOnboardingEndViewController

- (IBAction)doneButtonPressed:(UIButton *)sender {
    [self.delegate userDidFinishOnboarding];
}

@end
