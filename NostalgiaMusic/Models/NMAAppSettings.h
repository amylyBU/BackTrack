//
//  NMAAppSettings.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NMAAppSettings : NSObject

+ (instancetype)sharedSettings;

- (void)setCompleteOnboarding:(BOOL)value;
- (BOOL)hasCompletedOnboarding;

@end
