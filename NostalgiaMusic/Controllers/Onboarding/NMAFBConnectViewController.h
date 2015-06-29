//
//  NMAFBConnectViewController.h
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/29/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMAAppSettings.h"

@protocol NMAOnboardingViewControllerDelegate <NSObject>

- (void)userDidFinishOnboarding;

@end

@interface NMAFBConnectViewController : UIViewController <FBSDKLoginButtonDelegate>

@property (weak, nonatomic) id <NMAOnboardingViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextView *textDescription;

@end
