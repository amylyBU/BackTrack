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
#import "NMAAppSettings.h"

@implementation NMAFBConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)configureUI {
    self.navigationController.navigationBar.hidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.view.backgroundColor = [UIColor nma_skyBlueBackground];

    self.appDescriptionLabel.textColor = [UIColor nma_boldOrange];
    self.appDescriptionLabel.font = [UIFont nma_proximaNovaSemiBoldWithSize:19.0];

    self.facebookDisclaimerLabel.textColor = [UIColor nma_tealGreen];
    self.facebookDisclaimerLabel.font = [UIFont nma_proximaNovaLightWithSize:12.5];

    [self.notNowButton setTitleColor:[UIColor nma_lightGray] forState:UIControlStateNormal];
    [self.notNowButton.titleLabel setFont:[UIFont nma_proximaNovaLightWithSize:15.0]];

    self.facebookBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.facebookSignInButton setTitleColor:[UIColor nma_facebookBlue] forState:UIControlStateNormal];
    [self.facebookSignInButton.titleLabel setFont:[UIFont nma_proximaNovaSemiBoldWithSize:18.0f]];
}

- (IBAction)signInButtonPressed:(UIButton *)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    NSArray *requestedPermissions = @[@"email", @"public_profile", @"user_photos", @"user_posts", @"user_status"];
    [login logInWithReadPermissions:requestedPermissions
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    // TODO: handle error
                                } else if (result.isCancelled) {
                                    // TODO: handle cancellations
                                } else {
                                        [[NMAAppSettings sharedSettings] setAccessToken:result.token];
                                }
                                [[NMAAppSettings sharedSettings] setUserOnboardingStatusToCompleted];
                                [self.delegate userDidFinishOnboarding];
                            }];
    //TODO: notifications for profile changes, access token changes/expirations etc.
}

- (IBAction)notNowButton:(UIButton *)sender {
    [[NMAAppSettings sharedSettings] setUserOnboardingStatusToCompleted];
    [self.delegate userDidFinishOnboarding];
}

@end
