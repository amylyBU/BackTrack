//
//  NMALoginViewController.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMALoginViewController.h"
#import "AppDelegate.h"

@interface NMALoginViewController ()

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;

@end

@implementation NMALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.descriptionTextField.editable = NO;
    self.loginButtonView.delegate = self;
}

- (IBAction)skipButtonPressed:(UIButton *)sender {
    [[NMAAppSettings sharedSettings] setUserDefaultSettingForKey:@"hasOnboarded" withBool:YES];
    [self.delegate onboardingCompleted];
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error) {
        //TODO: handle error
        return;
    } else if (result.isCancelled) {
        //TODO: handle cancellation
    } else {
        [[NMAAppSettings sharedSettings] setAccessTokenForKey:@"accessToken" withAccessToken:result.token];
    }
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[NMAAppSettings sharedSettings] getUserDefaultSettingForKey:@"hasOnboarded"] ? [app goToHome] : [app goToOnboarding];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    [[NMAAppSettings sharedSettings] setAccessTokenForKey:@"accessToken" withAccessToken:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app goToLogin];
}


@end
