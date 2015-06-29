//
//  AppDelegate.m
//  NostalgiaMusic
//
//  Created by Bryan Weber on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "AppDelegate.h"
#import "NMAAppSettings.h"
#import "NMAHomeViewController.h"
#import "NMAOnboardingViewController.h"
#import "NMALoginViewController.h"
#import "NMAYearCollectionViewController.h"
#import "NMAOnboardingEndViewController.h"

@interface AppDelegate () <NMALoginViewControllerDelegate, NMAOnboardingViewControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([[NMAAppSettings sharedSettings] userHasCompletedOnboarding]) {
        [self goToHome];
    } else {
        [self goToOnboarding];
    }
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

#pragma mark - Private Methods

- (void)goToLogin {
    NMALoginViewController *loginVC = [[NMALoginViewController alloc] init];
    loginVC.delegate = self;
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
}

- (void)goToOnboarding {
    NMAOnboardingViewController *onboardingVC = [[NMAOnboardingViewController alloc] init];
    onboardingVC.delegate = self;
    self.window.rootViewController = onboardingVC;
    [self.window makeKeyAndVisible];
}

- (void)goToOnboardingEnd {
    NMAOnboardingEndViewController *onboardingEndVC = [[NMAOnboardingEndViewController alloc] init];
    onboardingEndVC.delegate = self;
    self.window.rootViewController = onboardingEndVC;
    [self.window makeKeyAndVisible];
}

- (void)goToHome {
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:[NMAHomeViewController new]];
    self.window.rootViewController = homeNav;
    [self.window makeKeyAndVisible];
}

#pragma mark - NMALoginViewControllerDelegate

- (void)userDidLogOut {
    [[NMAAppSettings sharedSettings] setAccessToken:nil];
    [self goToHome];
}

- (void)userDidFinishConnectingFB {
    [self goToOnboardingEnd];
}

#pragma mark - NMAOnboardingViewControllerDelegate

- (void) userDidSeeWelcome {
    [self goToLogin];
}

- (void)userDidFinishOnboarding {
    [[NMAAppSettings sharedSettings] setUserOnboardingStatusToCompleted];
    [self goToHome];
}

@end
