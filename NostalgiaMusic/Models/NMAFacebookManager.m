//
//  NMAFacebookManager.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/24/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "NMAFacebookManager.h"
#import "NMAAppSettings.h"
#import "AppDelegate.h"

@interface NMAFacebookManager ()

@end

@implementation NMAFacebookManager

#pragma mark - Singleton

+ (instancetype)sharedManager {
    static NMAFacebookManager *FBManager = nil;
    @synchronized (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^ {
            FBManager = [[NMAFacebookManager alloc] init];
        });
    }
    return FBManager;
}

#pragma mark - Facebook Authentication

- (BOOL)userIsLoggedIn {
    NSString *accessToken = [self getAccessTokenForKey:@"accessToken"];
    return accessToken ? YES : NO; // TODO: must check if the access token has expired
}

// for FBSDKAccessToken (key = "accessToken")
- (void)setAccessTokenForKey:(NSString *)key withAccessToken:(FBSDKAccessToken *)token {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token.tokenString forKey:key];
    [userDefaults synchronize];
}

- (NSString *)getAccessTokenForKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error) {
        //TODO: handle error
        return;
    } else if (result.isCancelled) {
        //TODO: handle cancellation
    } else {
        [[NMAFacebookManager sharedManager] setAccessTokenForKey:@"accessToken" withAccessToken:result.token];
    }
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[NMAAppSettings sharedSettings] getUserDefaultSettingForKey:@"hasOnboarded"] ? [app goToHome] : [app goToOnboarding];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    [[NMAFacebookManager sharedManager] setAccessTokenForKey:@"accessToken" withAccessToken:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app goToLogin];
}

@end
