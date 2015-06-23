//
//  NMAAppSettings.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, NMASettingBool) {
    Onboard,
    //...
    AutoplayMusic
};

@interface NMAAppSettings : NSObject

+ (instancetype)sharedSettings;
- (void)setUserBool:(NMASettingBool)key value:(BOOL)value;
- (BOOL)getUserBool:(NMASettingBool)key;

@end
