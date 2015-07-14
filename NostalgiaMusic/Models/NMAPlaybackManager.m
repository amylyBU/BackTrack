//
//  NMAPlaybackManager.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAPlaybackManager.h"
#import "NMAContentTableViewController.h"
#import <AVFoundation/AVFoundation.h>

static NMAPlaybackManager *sharedPlayer;

@interface NMAPlaybackManager ()

@property (strong, nonatomic) AVPlayer *audioPlayer;
@property (strong, nonatomic) AVURLAsset *audioAsset;

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

#pragma mark - Public Methods

- (void)setUpWithURL:(NSURL *)url {
    sharedPlayer.audioAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    sharedPlayer.audioPlayerItem = [[AVPlayerItem alloc] initWithAsset:sharedPlayer.audioAsset];
    [sharedPlayer.audioPlayer replaceCurrentItemWithPlayerItem:sharedPlayer.audioPlayerItem];
    NSLog(@"song url is now: %@", sharedPlayer.audioAsset.URL);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:sharedPlayer.audioPlayerItem];
}

- (void)startPlaying {
    [sharedPlayer.audioPlayer play];
}

- (void)pausePlaying {
    [sharedPlayer.audioPlayer pause];
}

#pragma mark- NMAtodaysSongCell Delegate

- (void)itemDidFinishPlaying:(NSNotification *)notification {
    [sharedPlayer setUpWithURL:sharedPlayer.audioAsset.URL];
    [[NSNotificationCenter defaultCenter] postNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:self];
}

@end
