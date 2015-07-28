//
//  NMAPlaybackManager.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAPlaybackManager.h"
#import <AVFoundation/AVFoundation.h>

@interface NMAPlaybackManager ()

@property (nonatomic) int previousRate;

@end

@implementation NMAPlaybackManager

#pragma mark - Singleton

+ (instancetype)sharedPlayer {
    static NMAPlaybackManager *sharedPlayerManagerInstance = nil;
    static dispatch_once_t onceToken;
    if (!sharedPlayerManagerInstance) {
        dispatch_once(&onceToken, ^{
            sharedPlayerManagerInstance = [[NMAPlaybackManager alloc] init];
            sharedPlayerManagerInstance.audioPlayer = [[AVPlayer alloc] init];
            [sharedPlayerManagerInstance.audioPlayer addObserver:sharedPlayerManagerInstance
                                                      forKeyPath:@"rate"
                                                         options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                                         context:0];
        });
    }
    return sharedPlayerManagerInstance;
}

#pragma mark - Public Methods

- (void)setUpAVPlayerWithURL:(NSURL *)url {
    [NMAPlaybackManager sharedPlayer].audioAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    [NMAPlaybackManager sharedPlayer].audioPlayerItem = [[AVPlayerItem alloc] initWithAsset:[NMAPlaybackManager sharedPlayer].audioAsset];
    [[NMAPlaybackManager sharedPlayer].audioPlayer replaceCurrentItemWithPlayerItem:[NMAPlaybackManager sharedPlayer].audioPlayerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[NMAPlaybackManager sharedPlayer].audioPlayerItem];
}

- (void)startPlaying {
    [[NMAPlaybackManager sharedPlayer].audioPlayer play];
}

- (void)pausePlaying {
    [[NMAPlaybackManager sharedPlayer].audioPlayer pause];
}

#pragma mark - Song End Notification

- (void)itemDidFinishPlaying:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:[NMAPlaybackManager sharedPlayer].audioPlayerItem];
    [[NSNotificationCenter defaultCenter] postNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:self];
    [[NMAPlaybackManager sharedPlayer] setUpAVPlayerWithURL:[NMAPlaybackManager sharedPlayer].audioAsset.URL];
}

#pragma mark - Key-Value Observer Handling

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    NSNumber *newValue = [change objectForKey:NSKeyValueChangeNewKey];
    NSNumber *oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    if (![newValue isEqual:oldValue]) {
        if ([NMAPlaybackManager sharedPlayer].audioPlayer.rate) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeAVPlayerNotification" object:self];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseAVPlayerNotification" object:self];
        }
    }
}

@end
