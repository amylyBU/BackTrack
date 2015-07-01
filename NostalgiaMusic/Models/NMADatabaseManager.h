//
//  NMADatabaseManager.h
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NMABillboardSong;

@interface NMADatabaseManager : NSObject

+ (instancetype)sharedDatabaseManager;

- (NMABillboardSong *)getSongFromYear:(NSString *)year;

@end
