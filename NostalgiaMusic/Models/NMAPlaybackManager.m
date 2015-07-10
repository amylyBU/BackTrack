//
//  NMAPlaybackManager.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAPlaybackManager.h"
#import <AVFoundation/AVFoundation.h>

static NMAPlaybackManager *sharedPlayer;

@interface NMAPlaybackManager ()

@property (strong, nonatomic) AVPlayer *audioPlayer;

@end

@implementation NMAPlaybackManager

#pragma mark - Singleton

+ (instancetype)sharedAudioPlayer {
    static dispatch_once_t onceToken;
    if (!sharedPlayer) {
        dispatch_once(&onceToken, ^{
            sharedPlayer = [[NMAPlaybackManager alloc] init];
            sharedPlayer.audioPlayer = [[AVPlayer alloc] init];
        });
    }
    return sharedPlayer;
}

- (void)setUpWithURL:(NSURL *)url {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVPlayerItem *currentItem = [[AVPlayerItem alloc] initWithAsset:asset];
    [sharedPlayer.audioPlayer replaceCurrentItemWithPlayerItem:currentItem];
    NSLog(@"song url is now: %@", asset.URL);
}

- (void)startPlaying {
    NSLog(@"PLAYING THE SONG");
    [sharedPlayer.audioPlayer play];
}

- (void)pausePlaying {
    NSLog(@"PAUSING THE SONG");
    [sharedPlayer.audioPlayer pause];
}

@end
