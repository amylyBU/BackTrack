//
//  NMAFBConnectViewController.h
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/29/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMAOnboardingCompletionDelegate.h"

@interface NMAFBConnectViewController : UIViewController

@property (weak, nonatomic) id <NMAOnboardingCompletionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *facebookDisclaimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *appDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *notNowButton;
@property (weak, nonatomic) IBOutlet UIImageView *facebookLogoImageView;
@property (weak, nonatomic) IBOutlet UIButton *facebookSignInButton;
@property (weak, nonatomic) IBOutlet UIView *facebookBackgroundView;

@end
