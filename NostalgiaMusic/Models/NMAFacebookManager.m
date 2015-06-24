//
//  NMAFacebookManager.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/24/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAFacebookManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation NMAFacebookManager

#pragma mark - Singleton

+ (instancetype)sharedManager {
    static NMAFacebookManager *FBManager = nil;
    @synchronized (self) {
        static dispatch_once_t once;
        dispatch_once(&once, ^ {
            FBManager = [[NMAFacebookManager alloc] init];
        });
    }
    return FBManager;
}

#pragma mark - Facebook Authentication



#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    // sent to the delegate when the button was used to login
    NSLog(@"user has logged in");
    
}

- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    // sent to the delegate whe the button was used to logout
    NSLog(@"user has logged out");
    
}
@end
