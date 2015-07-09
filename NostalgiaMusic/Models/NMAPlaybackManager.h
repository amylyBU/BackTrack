//
//  NMAPlaybackManager.h
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface NMAPlaybackManager : AVPlayer

+ (instancetype)sharedPlayerWithURL:(NSURL *)previewUrl;
- (void)startPlaying;
- (void)pausePlaying;

@end
