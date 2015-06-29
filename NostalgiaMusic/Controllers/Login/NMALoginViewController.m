//
//  NMALoginViewController.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMALoginViewController.h"
#import "AppDelegate.h"
#import "NMAOnboardingEndViewController.h"

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
    [self.delegate userDidFinishConnectingFB]; // will always go to the onboardingEnd
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error) {
        //TODO: handle error
        return;
    } else if (result.isCancelled) {
        [self skipButtonPressed:loginButton];
    } else {
        [[NMAAppSettings sharedSettings] setAccessToken:result.token];
    }
    [self.delegate userDidFinishConnectingFB];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    [self.delegate userDidLogOut];
}

@end
