//
//  NMADatabaseManager.h
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NMASong;

@interface NMADatabaseManager : NSObject

+ (instancetype)sharedDatabaseManager;

- (NMASong *)getSongFromYear:(NSString *)year;

@end
