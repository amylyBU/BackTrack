//
//  NMALoginViewController.h
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMAAppSettings.h"

@protocol NMALoginViewControllerDelegate <NSObject> 

- (void)userDidSkipLogin;
- (void)userDidLogOut;
- (void)userDidLogIn;

@end

@interface NMALoginViewController : UIViewController <FBSDKLoginButtonDelegate>

@property (weak, nonatomic) id <NMALoginViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButtonView;
@property (weak, nonatomic) IBOutlet UIButton *skipFacebookLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@end
