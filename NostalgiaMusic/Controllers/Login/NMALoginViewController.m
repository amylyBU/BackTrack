//
//  NMALoginViewController.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMALoginViewController.h"
#import "AppDelegate.h"
#import "NMAAppSettings.h"

@interface NMALoginViewController ()

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;

@end

@implementation NMALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.descriptionTextField.editable = NO;
    self.loginButtonView.delegate = [NMAFacebookManager sharedManager];
}

// NOTE: this is the same method as in OnboardingViewController
- (IBAction)skipButtonPressed:(UIButton *)sender {
    [[NMAAppSettings sharedSettings] setUserDefaultSettingForKey:@"hasOnboarded" withBool:YES];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app goToHome];
}

@end
