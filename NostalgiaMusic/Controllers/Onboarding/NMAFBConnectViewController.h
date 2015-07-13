//
//  NMAFBConnectViewController.h
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/29/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMAAppSettings.h"
#import "NMAOnboardingCompletionDelegate.h"

@interface NMAFBConnectViewController : UIViewController <FBSDKLoginButtonDelegate>

@property (weak, nonatomic) id <NMAOnboardingCompletionDelegate> delegate;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *facebookDisclaimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *appDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *notNowButton;
@property (weak, nonatomic) IBOutlet UILabel *facebookSignInLabel;
@property (weak, nonatomic) IBOutlet UIImageView *facebookLogoImageView;


@end
