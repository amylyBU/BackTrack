//
//  NMAAppSettings.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAAppSettings.h"

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

- (void)setUserDefaultSettingForKey:(NSString *)key withBool:(BOOL)value {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

- (BOOL)getUserDefaultSettingForKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}
- (void)setAccessTokenForKey:(NSString *)key withAccessToken:(FBSDKAccessToken *)token {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token.tokenString forKey:key];
    [userDefaults synchronize];
}

- (NSString *)getAccessTokenForKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

- (BOOL)userIsLoggedIn {
    return [self getAccessTokenForKey:@"accessToken"] != nil; // TODO: must check if the access token has expired
}


@end
