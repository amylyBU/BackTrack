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
<<<<<<< HEAD
#import "NMAOnboardingViewController.h"
=======
#import "NMALoginViewController.h"

>>>>>>> 8581a70... Initial commit

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
<<<<<<< HEAD
    
    //TODO: replace with a NMASettings check once its merged
    NMAAppSettings *settings = [NMAAppSettings sharedSettings];
    if(![settings hasCompletedOnboarding]) {
        [self goToOnboarding];
    } else {
        [self goToHome];
    }
    
=======
    self.window.rootViewController = [NMALoginViewController new];
>>>>>>> 8581a70... Initial commit
    [self.window makeKeyAndVisible];
    
    [FBSDKLoginButton class];
    
    return YES;
}

#pragma mark - Instance Methods

- (void) completedOnboarding {
    [[NMAAppSettings sharedSettings] setCompleteOnboarding:YES];
    [self goToHome];
}

- (void) goToOnboarding {
    //TODO: replace with actual first VC of onboarding once it is complete
    NMAOnboardingViewController *onboardVC = [NMAOnboardingViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:onboardVC];
    self.window.rootViewController = navigationController;
}

- (void) goToHome {
    NMAHomeViewController *homeVC = [NMAHomeViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeVC];
    self.window.rootViewController = navigationController;
}

@end
