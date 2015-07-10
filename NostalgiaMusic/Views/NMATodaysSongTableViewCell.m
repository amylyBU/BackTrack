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

static NSString * const kPlayImageName = @"play-circle-icon";
static NSString * const kPauseImageName = @"pause-circle-icon";

@interface NMATodaysSongTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation NMATodaysSongTableViewCell

- (void)configureCellForSong:(NMASong *)song {
    [self layoutIfNeeded];
    self.songTitleLabel.text = song.title;
    self.songTitleLabel.font = [UIFont NMA_proximaNovaSemiBoldWithSize:24.0f];
    self.songTitleLabel.textColor = [UIColor NMA_almostBlack];
    self.artistLabel.text = song.artistAsAppearsOnLabel;
    self.artistLabel.font = [UIFont NMA_proximaNovaLightWithSize:17.0f];
    self.artistLabel.textColor = [UIColor NMA_darkGray];
    NSURL *albumImageUrl = [NSURL URLWithString:song.albumImageUrlsArray[0]];
    self.albumImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:albumImageUrl]];
    self.albumImage.layer.cornerRadius = CGRectGetHeight(self.albumImage.frame) /2;
    self.albumImage.layer.masksToBounds = YES;
}

- (IBAction)playButtonPressed:(UIButton *)sender {
    if ([sender.currentImage isEqual:[UIImage imageNamed:kPlayImageName]]) {
        [[NMAPlaybackManager sharedAudioPlayer] startPlaying];
        [self.playButton setImage:[UIImage imageNamed:kPauseImageName] forState:UIControlStateNormal];
    } else {
        [[NMAPlaybackManager sharedAudioPlayer] pausePlaying];
        [self.playButton setImage:[UIImage imageNamed:kPlayImageName] forState:UIControlStateNormal];
    }
}



@end
