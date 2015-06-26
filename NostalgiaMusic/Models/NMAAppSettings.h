//
//  NMAAppSettings.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface NMAAppSettings : NSObject

+ (instancetype)sharedSettings;

- (void)setUserDefaultSettingForKey:(NSString *)key withBool:(BOOL)value;
- (BOOL)getUserDefaultSettingForKey:(NSString *)key;
- (BOOL)userIsLoggedIn;
- (void)setAccessTokenForKey:(NSString *)key withAccessToken:(FBSDKAccessToken *)token;
- (NSString *)getAccessTokenForKey:(NSString *)key;


@end
