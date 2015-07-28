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

static NSString * const kPlayImageName = @"play-circle-button";
static NSString * const kPauseImageName = @"pause-circle-button";

@interface NMATodaysSongTableViewCell ()

@property (strong, nonatomic) NMASong *song;
@property (weak, nonatomic) IBOutlet UIImageView *musicHandleImage;

@end

@implementation NMATodaysSongTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Public Methods

- (void)configureCellForSong:(NMASong *)song {
    [self layoutIfNeeded];
    self.song = song;
    self.songTitleLabel.text = song.title;
    self.songTitleLabel.font = [UIFont NMA_proximaNovaSemiBoldWithSize:24.0f];
    self.songTitleLabel.textColor = [UIColor NMA_almostBlack];
    self.artistLabel.text = song.artistAsAppearsOnLabel;
    self.artistLabel.font = [UIFont NMA_proximaNovaLightWithSize:17.0f];
    self.artistLabel.textColor = [UIColor NMA_darkGray];
    UIImage *albumImage = song.albumImageUrl600x600 ? [UIImage imageWithData:[NSData dataWithContentsOfURL:song.albumImageUrl600x600]] : [UIImage NMA_defaultRecord];
    self.albumImageView.image = albumImage;
    self.albumImageView.layer.cornerRadius = CGRectGetHeight(self.albumImageView.frame) /2;
    self.albumImageView.layer.masksToBounds = YES;
    if ([[NMAAppSettings sharedSettings] userDidAutoplay]) {
        [self.playButton setImage:[UIImage imageNamed:kPauseImageName] forState:UIControlStateNormal];
    }
}

- (void)configureEmptyCell {
    NMASong *dummySong = [NMASong new];
    dummySong.title = @"Track Name";
    dummySong.artistAsAppearsOnLabel = @"Artist Name";
    dummySong.albumImageUrl600x600 = nil;
    [self configureCellForSong:dummySong];
}

#pragma mark - Private Methods

- (IBAction)playButtonPressed:(UIButton *)sender {
    if ([NMAPlaybackManager sharedPlayer].audioPlayer.rate) {
        [[NMAPlaybackManager sharedPlayer] pausePlaying];
        [self.playButton setImage:[UIImage imageNamed:kPlayImageName] forState:UIControlStateNormal];
    } else {
        [[NMAPlaybackManager sharedPlayer] startPlaying];
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
