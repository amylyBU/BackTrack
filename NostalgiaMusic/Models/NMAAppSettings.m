//
//  NMAAppSettings.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAAppSettings.h"
#import "NMAFacebookManager.h"

@implementation NMAAppSettings

#pragma mark - Class Methods

+ (instancetype)sharedSettings {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - NSUserDefaults Getter and Setter Methods

//- (BOOL)hasCompletedOnboarding {
//    return [self getUserDefaultSettingForKey:@"hasOnboarded"];
//}

// for "hasOnboarded" and "autoplay" keys
- (void)setUserDefaultSettingForKey:(NSString *)key withBool:(BOOL)value {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

- (BOOL)getUserDefaultSettingForKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}

@end
