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
#import "UIImage+NMAImages.h"

#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const kPlayImageName = @"play-circle-button";
static NSString * const kPauseImageName = @"pause-circle-button";

@interface NMATodaysSongTableViewCell ()

@property (strong, nonatomic) NMASong *song;

@end


@implementation NMATodaysSongTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.songTitleLabel.font = [UIFont nma_proximaNovaSemiBoldWithSize:24.0f];
    self.artistLabel.font = [UIFont nma_proximaNovaLightWithSize:17.0f];
    self.artistLabel.textColor = [UIColor nma_darkGray];
}

#pragma mark - Public Methods

- (void)configureCellForSong:(NMASong *)song {
    [self layoutIfNeeded];
    self.song = song;
    self.songTitleLabel.text = song.title;
    self.songTitleLabel.textColor = [UIColor nma_almostBlack];
    self.artistLabel.text = song.artistAsAppearsOnLabel;
    song.albumImageUrl600x600 ? [self.albumImageView sd_setImageWithURL:song.albumImageUrl600x600] : [self.albumImageView setImage:[UIImage nma_defaultRecord]] ;
    self.albumImageView.layer.cornerRadius = CGRectGetHeight(self.albumImageView.frame) /2;
    self.albumImageView.layer.masksToBounds = YES;
    if ([[NMAAppSettings sharedSettings] userDidAutoplay]) {
        [self.playButton setImage:[UIImage imageNamed:kPauseImageName] forState:UIControlStateNormal];
    }
}

- (void)configureEmptyCell {
    NMASong *dummySong = [NMASong new];
    dummySong.title = @"Track Title";
    dummySong.artistAsAppearsOnLabel = @"Artist";
    dummySong.albumImageUrl600x600 = nil;
    [self configureCellForSong:dummySong];
}

#pragma mark - Private Methods

- (IBAction)playButtonPressed:(UIButton *)sender {
    NMAPlaybackManager *shared = [NMAPlaybackManager sharedPlayer];
    if (shared.audioPlayer.rate) {
        [shared pausePlaying];
        [self.playButton setImage:[UIImage imageNamed:kPlayImageName] forState:UIControlStateNormal];
    } else {
        [shared startPlaying];
        [self.playButton setImage:[UIImage imageNamed:kPauseImageName] forState:UIControlStateNormal];
    }
}

- (IBAction)iTunesButtonPressed:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:self.song.trackViewUrl];
}

- (void)changePlayButtonImageToPlay {
    [self.playButton setImage:[UIImage imageNamed:kPlayImageName] forState:UIControlStateNormal];
}

@end
