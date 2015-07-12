//
//  NMATodaysSongTableViewCell.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/4/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMATodaysSongTableViewCell.h"
#import "NMASong.h"
#import "NMAAppSettings.h"
#import "NMAPlaybackManager.h"
#import "UIFont+NMAFonts.h"
#import "UIColor+NMAColors.h"
#import <AVFoundation/AVFoundation.h>

static NSString * const kPlayImageName = @"play-circle-icon";
static NSString * const kPauseImageName = @"pause-circle-icon";

@implementation NMATodaysSongTableViewCell

#pragma mark - Public Methods

- (void)configureCellForSong:(NMASong *)song {
    [self layoutIfNeeded];
    self.songTitleLabel.text = song.title;
    self.songTitleLabel.font = [UIFont NMA_proximaNovaSemiBoldWithSize:24.0f];
    self.songTitleLabel.textColor = [UIColor NMA_almostBlack];
    self.artistLabel.text = song.artistAsAppearsOnLabel;
    self.artistLabel.font = [UIFont NMA_proximaNovaLightWithSize:17.0f];
    self.artistLabel.textColor = [UIColor NMA_darkGray];
    self.albumImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:song.albumImageUrl600x600]];
    self.albumImage.layer.cornerRadius = CGRectGetHeight(self.albumImage.frame) /2;
    self.albumImage.layer.masksToBounds = YES;
    if ([[NMAAppSettings sharedSettings] userDidAutoplay]) {
        [self.playButton setImage:[UIImage imageNamed:kPauseImageName] forState:UIControlStateNormal];
    }
}

#pragma mark - Private Methods

- (IBAction)playButtonPressed:(UIButton *)sender {
    if ([sender.currentImage isEqual:[UIImage imageNamed:kPlayImageName]]) {
        [[NMAPlaybackManager sharedAudioPlayer] startPlaying];
        [self.playButton setImage:[UIImage imageNamed:kPauseImageName] forState:UIControlStateNormal];
    } else {
        [[NMAPlaybackManager sharedAudioPlayer] pausePlaying];
        [self.playButton setImage:[UIImage imageNamed:kPlayImageName] forState:UIControlStateNormal];
    }
}

#pragma mark - NMATodaysSongCellDelegate Methods

- (void)changePlayButtonImage {
    [self.playButton setImage:[UIImage imageNamed:kPlayImageName] forState:UIControlStateNormal];
}


@end
