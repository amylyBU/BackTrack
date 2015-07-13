//
//  NMAFBConnectViewController.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/29/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAFBConnectViewController.h"
#import "UIColor+NMAColors.h"
#import "UIFont+NMAFonts.h"

@implementation NMAFBConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.delegate = self;
    self.loginButton.readPermissions = @[@"user_posts", @"user_photos"];
    [self configureUI];
}

- (void)configureUI {
    self.navigationController.navigationBar.hidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.view.backgroundColor = [UIColor NMA_skyBlueBackground];

    self.appDescriptionLabel.textColor = [UIColor NMA_boldOrange];
    self.appDescriptionLabel.font = [UIFont NMA_proximaNovaSemiBoldWithSize:19.0];

    self.facebookDisclaimerLabel.textColor = [UIColor NMA_tealGreen];
    self.facebookDisclaimerLabel.font = [UIFont NMA_proximaNovaLightWithSize:12.5];

    [self.notNowButton setTitleColor:[UIColor NMA_lightGray] forState:UIControlStateNormal];
    [self.notNowButton.titleLabel setFont:[UIFont NMA_proximaNovaLightWithSize:15.0]];

    [self.loginButton setBackgroundImage:nil forState:UIControlStateNormal];
    self.loginButton.backgroundColor = [UIColor whiteColor];

    for (id obj in self.loginButton.subviews) {
        [obj removeFromSuperview];
    }

    [self.loginButton addSubview:self.facebookSignInLabel];
    [self.loginButton addSubview:self.facebookIcon];
    self.facebookSignInLabel.font = [UIFont NMA_proximaNovaSemiBoldWithSize:18.0f];
    self.facebookSignInLabel.textColor = [UIColor NMA_facebookBlue];
}

- (IBAction)notNowButton:(UIButton *)sender {
    [[NMAAppSettings sharedSettings] setUserOnboardingStatusToCompleted];
    [self.delegate userDidFinishOnboarding];
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error) {
        //TODO: handle error
        return;
    } else if (result.isCancelled) {
        //TODO: handle cancellation
    } else {
        [[NMAAppSettings sharedSettings] setAccessToken:result.token];
    }
    [[NMAAppSettings sharedSettings] setUserOnboardingStatusToCompleted];
    [self.delegate userDidFinishOnboarding];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    [[NMAAppSettings sharedSettings] setAccessToken:nil];
    [self.delegate userDidFinishOnboarding];
}

@end
