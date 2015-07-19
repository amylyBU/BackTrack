//
//  NMAPlaybackManager.h
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "NMATodaysSongTableViewCell.h"

@interface NMAPlaybackManager : NSObject

@property (strong, nonatomic) AVPlayerItem *audioPlayerItem;
@property (strong, nonatomic) AVPlayer *audioPlayer;
@property (strong, nonatomic) AVURLAsset *audioAsset;

+ (instancetype)sharedPlayer;
- (void)setUpAVPlayerWithURL:(NSURL *)url;
- (void)startPlaying;
- (void)pausePlaying;

@end
