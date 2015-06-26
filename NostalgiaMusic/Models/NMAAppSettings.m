//
//  NMAAppSettings.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAAppSettings.h"

@implementation NMAAppSettings

static NSString * const kHasOnboardedSettingKey = @"kHasOnboardedSettingKey";
static NSString * const kAccessTokenSettingKey = @"kAccessTokenSettingKey";
static NSString * const kAutoplaySettingKey = @"kAutoplaySettingKey";

#pragma mark - Singleton

+ (instancetype)sharedSettings {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - NSUserDefaults Getter and Setter Methods

- (void)setUserDefaultSettingForKey:(NSString *)key withBool:(BOOL)value {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

- (BOOL)userDefaultSettingForKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}
- (void)setAccessTokenForKey:(NSString *)key withAccessToken:(FBSDKAccessToken *)token {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token.tokenString forKey:key];
    [userDefaults synchronize];
}

- (NSString *)accessTokenForKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

#pragma mark - Public Wrapper Methods

- (BOOL)userHasCompletedOnboarding {
    return [self userDefaultSettingForKey:kHasOnboardedSettingKey];
}

- (void)setUserOnboardingStatusToCompleted {
    [self setUserDefaultSettingForKey:kHasOnboardedSettingKey withBool:YES];
}

- (void)setAccessToken:(FBSDKAccessToken *)token {
    [self setAccessTokenForKey:kAccessTokenSettingKey withAccessToken:token];
}

- (NSString *)accessTokenString {
    return [self accessTokenForKey:kAccessTokenSettingKey];
}

- (BOOL)userIsLoggedIn {
    return [self accessTokenForKey:kAccessTokenSettingKey] != nil; // TODO: must check if the access token has expired
}


@end
