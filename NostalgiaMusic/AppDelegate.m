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

@interface AppDelegate () <NMALoginViewControllerDelegate>

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    NMAAppSettings *settings = [NMAAppSettings sharedSettings];
    
    if ([settings userIsLoggedIn]) {
        [settings getUserDefaultSettingForKey:@"hasOnboarded"] ? [self goToHome] : [self goToOnboarding];
        return YES;
    } else {
        [self goToLogin];
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                        didFinishLaunchingWithOptions:launchOptions];
    }
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

#pragma mark - Navigation

- (void)goToLogin {
    NMALoginViewController *loginVC = [[NMALoginViewController alloc] init];
    loginVC.delegate = self;
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
}

- (void)goToOnboarding {
    UINavigationController *onboardingNav = [[UINavigationController alloc] initWithRootViewController:[NMAOnboardingViewController new]];
    self.window.rootViewController = onboardingNav;
    [self.window makeKeyAndVisible];
}

- (void)goToHome {
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:[NMAHomeViewController new]];
    self.window.rootViewController = homeNav;
    [self.window makeKeyAndVisible];
}

#pragma mark - NMALoginViewControllerDelegate

- (void)onboardingCompleted {
    [self goToHome];
}
@end
