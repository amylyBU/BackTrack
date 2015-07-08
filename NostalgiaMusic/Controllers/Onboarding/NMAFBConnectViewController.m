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

@interface NMAFBConnectViewController ()

@end

@implementation NMAFBConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.delegate = self;
    self.loginButton.readPermissions = @[@"user_posts", @"user_photos"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self configureUI];
}

- (void)configureUI {
    self.navigationController.navigationBar.hidden = YES;

    self.view.backgroundColor = [UIColor NMA_skyBlueBackground];

    self.appDescription.textColor = [UIColor NMA_boldOrange];
    self.appDescription.font = [UIFont NMA_proximaNovaSemiBoldWithSize:19.0];

    self.facebookDisclaimer.textColor = [UIColor NMA_tealGreen];
    self.facebookDisclaimer.font = [UIFont NMA_proximaNovaLightWithSize:12.5];

    [self.notNowButton setTitleColor:[UIColor NMA_lightGray] forState:UIControlStateNormal];
    [self.notNowButton.titleLabel setFont:[UIFont NMA_proximaNovaLightWithSize:15.0]];

    // TODO: change background color of facebook button / format it.
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
