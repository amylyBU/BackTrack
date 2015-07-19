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
            
            // set up this shared manager instance to observe rate of its audioplayer.
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
    NSLog(@"song url is now: %@", [NMAPlaybackManager sharedPlayer].audioAsset.URL);
    
    // set up this manager instance to observe when player item finishes playing
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
    // stop observing previous player item
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:[NMAPlaybackManager sharedPlayer].audioPlayerItem];
    
    // post the notification that the previous player item has ended
    [[NSNotificationCenter defaultCenter] postNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:self];
    
    // set up the av player with a new player item
    [[NMAPlaybackManager sharedPlayer] setUpAVPlayerWithURL:[NMAPlaybackManager sharedPlayer].audioAsset.URL];
}

#pragma mark - Key-Value Observer Handling

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    NSNumber *newValue = [change objectForKey:NSKeyValueChangeNewKey];
    NSNumber *oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    
    //NSLog(@"new: %@, old: %@", newValue, oldValue);
    
  if (![newValue isEqual:oldValue]) {
        if ([NMAPlaybackManager sharedPlayer].audioPlayer.rate) { // rate = 1: playing
            NSLog(@"resumed song");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeAVPlayerNotification" object:self];
        } else { // rate = 0: paused
            NSLog(@"paused song");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseAVPlayerNotification" object:self];
        }
    }
}

@end
