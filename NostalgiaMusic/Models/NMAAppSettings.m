//
//  NMAAppSettings.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAAppSettings.h"

@implementation NMAAppSettings

typedef NS_ENUM(int, NMASettingBool) {
    Onboard,
    //...
    AutoplayMusic
};


#pragma mark - Class Methods

+ (instancetype)sharedSettings {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Setting NSUserDefaults

- (void)setCompleteOnboarding:(BOOL)value {
    [self setUserBool:Onboard value:value];
}

- (BOOL)hasCompletedOnboarding {
    return [self getUserBool:Onboard];
}

- (void)setUserBool:(NMASettingBool)key value:(BOOL)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:[@(key) stringValue]];
    [defaults synchronize];
}

- (BOOL)getUserBool:(NMASettingBool)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:[@(key) stringValue]];
}

@end
