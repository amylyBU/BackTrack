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

static NMAPlaybackManager *sharedPlayerManagerInstance;

@interface NMAPlaybackManager ()

@property (strong, nonatomic) AVPlayer *audioPlayer;
@property (strong, nonatomic) AVURLAsset *audioAsset;

@end

@implementation NMAPlaybackManager

#pragma mark - Singleton

+ (instancetype)sharedPlayer {
    static dispatch_once_t onceToken;
    if (!sharedPlayerManagerInstance) {
        dispatch_once(&onceToken, ^{
            sharedPlayerManagerInstance = [[NMAPlaybackManager alloc] init];
            sharedPlayerManagerInstance.audioPlayer = [[AVPlayer alloc] init];
            
            // self (the manager) observes avplayer rate property
            [sharedPlayerManagerInstance.audioPlayer addObserver:sharedPlayerManagerInstance
                                                      forKeyPath:@"rate"
                                                         options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                                         context:0];
        });
    }
    return sharedPlayerManagerInstance;
}

#pragma mark - Public Methods

- (void)setUpWithURL:(NSURL *)url {
    
    sharedPlayerManagerInstance.audioAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    sharedPlayerManagerInstance.audioPlayerItem = [[AVPlayerItem alloc] initWithAsset:sharedPlayerManagerInstance.audioAsset];
    [sharedPlayerManagerInstance.audioPlayer replaceCurrentItemWithPlayerItem:sharedPlayerManagerInstance.audioPlayerItem];
    NSLog(@"song url is now: %@", sharedPlayerManagerInstance.audioAsset.URL);
    
    // self observes when player item finishes playing
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:sharedPlayerManagerInstance.audioPlayerItem];
}

- (void)startPlaying {
    [sharedPlayerManagerInstance.audioPlayer play];
}

- (void)pausePlaying {
    [sharedPlayerManagerInstance.audioPlayer pause];
}

#pragma mark- NMAtodaysSongCell Delegate

- (void)itemDidFinishPlaying:(NSNotification *)notification {
    [sharedPlayerManagerInstance setUpWithURL:sharedPlayerManagerInstance.audioAsset.URL];
    [[NSNotificationCenter defaultCenter] postNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:self];
}

#pragma mark - Key-Value Observer Handling

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (sharedPlayerManagerInstance.audioPlayer.rate) { // rate = 1: playing
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeAVPlayerNotification" object:self];
    } else { // rate = 0: paused
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseAVPlayerNotification" object:self];
    }
}

@end
