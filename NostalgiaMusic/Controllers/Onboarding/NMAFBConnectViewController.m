//
//  NMAFBConnectViewController.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/29/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAFBConnectViewController.h"
#import "UIColor+NMAColors.h"
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
}

- (IBAction)signInButtonPressed:(UIButton *)sender {
    NMAAppSettings *shared = [NMAAppSettings sharedSettings];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    NSArray *requestedPermissions = @[@"email", @"public_profile", @"user_photos", @"user_posts", @"user_status"];
    [login logInWithReadPermissions:requestedPermissions
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    // TODO: handle error
                                } else if (result.isCancelled) {
                                    // TODO: handle cancellations
                                } else {
                                    [shared setAccessToken:result.token];
                                }
                                [shared setUserOnboardingStatusToCompleted];
                                [self.delegate userDidFinishOnboarding];
                            }];
    //TODO: notifications for profile changes, access token changes/expirations etc.
}

- (IBAction)notNowButton:(UIButton *)sender {
    [[NMAAppSettings sharedSettings] setUserOnboardingStatusToCompleted];
    [self.delegate userDidFinishOnboarding];
}

@end
