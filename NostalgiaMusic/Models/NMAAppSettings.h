//
//  NMAAppSettings.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMAFacebookManager.h"

@interface NMAAppSettings : NSObject

+ (instancetype)sharedSettings;

//- (BOOL)hasCompletedOnboarding;
- (void)setUserDefaultSettingForKey:(NSString *)key withBool:(BOOL)value;
- (BOOL)getUserDefaultSettingForKey:(NSString *)key;

@end
