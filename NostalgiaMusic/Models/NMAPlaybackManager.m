//
//  NMAPlaybackManager.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAPlaybackManager.h"
#import <AVFoundation/AVFoundation.h>

static NSString * const kResumeAVPlayerNotification = @"resumeAVPlayerNotification";
static NSString * const kPauseAVPlayerNotification = @"pauseAVPlayerNotification";

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

#pragma mark - Public AVPlayer Methods

- (void)setUpAVPlayerWithURL:(NSURL *)url {
    NMAPlaybackManager *shared = [NMAPlaybackManager sharedPlayer];
    shared.audioAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    shared.audioPlayerItem = [[AVPlayerItem alloc] initWithAsset:shared.audioAsset];
    [shared.audioPlayer replaceCurrentItemWithPlayerItem:shared.audioPlayerItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:shared.audioPlayerItem];
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
        NSString *notification = [NMAPlaybackManager sharedPlayer].audioPlayer.rate ? kResumeAVPlayerNotification : kPauseAVPlayerNotification;
        [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
    }
}

@end
