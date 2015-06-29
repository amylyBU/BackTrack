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
#import "NMAYearCollectionViewController.h"
#import "NMAFBConnectViewController.h"

@interface AppDelegate () <NMAOnboardingViewControllerDelegate>

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

- (void)goToOnboarding {
    NMAFBConnectViewController *FBConnectVC = [[NMAFBConnectViewController alloc] init];
    FBConnectVC.delegate = self;
    UINavigationController *FBConnectNav = [[UINavigationController alloc] initWithRootViewController:FBConnectVC];
    self.window.rootViewController = FBConnectNav;
    [self.window makeKeyAndVisible];
}

- (void)goToHome {
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:[NMAHomeViewController new]];
    self.window.rootViewController = homeNav;
    [self.window makeKeyAndVisible];
}

#pragma mark - NMAOnboardingViewControllerDelegate

- (void)userDidFinishOnboarding {
    [[NMAAppSettings sharedSettings] setUserOnboardingStatusToCompleted];
    [self goToHome];
}

@end
