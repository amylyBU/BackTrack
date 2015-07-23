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
#import "NMASplashScreenViewController.h"

@interface AppDelegate () <NMAOnboardingCompletionDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [self goToSplashScreen];
    
    SEL transitionMethod;
    if ([[NMAAppSettings sharedSettings] userHasCompletedOnboarding]) {
        transitionMethod = @selector(goToHome);
    } else {
        transitionMethod = @selector(goToOnboarding);
    }
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:transitionMethod userInfo:nil repeats:NO];
    
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

- (void)goToSplashScreen {
    NMASplashScreenViewController *splashScreenVC = [[NMASplashScreenViewController alloc] init];
    self.window.rootViewController = splashScreenVC;
    [self.window makeKeyAndVisible];
}

- (void)goToOnboarding {
    NMAFBConnectViewController *FBConnectVC = [[NMAFBConnectViewController alloc] init];
    FBConnectVC.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:FBConnectVC];
    self.window.rootViewController = navigationController;
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
    [[NMAAppSettings sharedSettings] setAutoplaySettingToOn];
    [self goToHome];
}

@end
