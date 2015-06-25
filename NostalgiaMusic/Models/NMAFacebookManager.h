//
//  NMAFacebookManager.h
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/24/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
@import FBSDKCoreKit;
@import FBSDKLoginKit;

@interface NMAFacebookManager : NSObject <FBSDKLoginButtonDelegate>

+ (instancetype)sharedManager;

- (BOOL)userIsLoggedIn;
- (void)setAccessTokenForKey:(NSString *)key withAccessToken:(FBSDKAccessToken *)token;
- (NSString *)getAccessTokenForKey:(NSString *)key;

@end
