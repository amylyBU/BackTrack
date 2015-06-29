//
//  NMAFBConnectViewController.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/29/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAFBConnectViewController.h"

@interface NMAFBConnectViewController ()

@end

@implementation NMAFBConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.delegate = self;
}

- (IBAction)notNowButton:(UIButton *)sender {
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
    [self.delegate userDidFinishOnboarding];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    [self.delegate userDidDisconnectFB];
}

@end
