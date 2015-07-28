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

    self.view.backgroundColor = [UIColor NMA_skyBlueBackground];

    self.appDescriptionLabel.textColor = [UIColor NMA_boldOrange];
    self.appDescriptionLabel.font = [UIFont NMA_proximaNovaSemiBoldWithSize:19.0];

    self.facebookDisclaimerLabel.textColor = [UIColor NMA_tealGreen];
    self.facebookDisclaimerLabel.font = [UIFont NMA_proximaNovaLightWithSize:12.5];

    [self.notNowButton setTitleColor:[UIColor NMA_lightGray] forState:UIControlStateNormal];
    [self.notNowButton.titleLabel setFont:[UIFont NMA_proximaNovaLightWithSize:15.0]];

    self.facebookBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.facebookSignInButton setTitleColor:[UIColor NMA_facebookBlue] forState:UIControlStateNormal];
    [self.facebookSignInButton.titleLabel setFont:[UIFont NMA_proximaNovaSemiBoldWithSize:18.0f]];
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
                                    if (result.grantedPermissions.count == requestedPermissions.count) {
                                        [[NMAAppSettings sharedSettings] setAccessToken:result.token];
                                    }
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
