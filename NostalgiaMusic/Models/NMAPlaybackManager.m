//
//  NMAPlaybackManager.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAPlaybackManager.h"
#import <AVFoundation/AVFoundation.h>

@implementation NMAPlaybackManager

#pragma mark - Singleton

+ (instancetype)sharedPlayerWithURL:(NSURL *)previewUrl {
    static id sharedPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlayer = [[AVPlayer alloc] initWithURL:previewUrl];
    });
    return sharedPlayer;
}

- (void)startPlaying {
    [self play];
}

- (void)pausePlaying {
    [self pause];
}
@end
