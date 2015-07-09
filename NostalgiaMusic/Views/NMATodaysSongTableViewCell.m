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

static NSString * const kPlayImageName = @"play-circle-icon";
static NSString * const kPauseImageName = @"pause-circle-icon";

@interface NMATodaysSongTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) AVPlayer *audioPlayer;

@end

@implementation NMATodaysSongTableViewCell

- (void)configureCellForSong:(NMASong *)song {
    self.songTitleLabel.text = song.title;
    self.artistLabel.text = song.artistAsAppearsOnLabel;
    
    NSURL *albumImageUrl = [NSURL URLWithString:song.albumImageUrlsArray[0]];
    self.albumImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:albumImageUrl]];
    self.albumImage.layer.cornerRadius = CGRectGetHeight(self.albumImage.frame) /2;
    self.albumImage.layer.masksToBounds = YES;
    
    [self setUpMusicPlayerWithUrl:[NSURL URLWithString:song.previewURL]];
}

- (void)setUpMusicPlayerWithUrl:(NSURL *)previewUrl {
    self.audioPlayer = [NMAPlaybackManager sharedPlayerWithURL:previewUrl];
    
    if (self.audioPlayer) {
        NSLog(@"successful audioplayer init");
        //if ([[NMAAppSettings sharedSettings] userDidAutoplay]) {
        if (NO) {
            [self.playButton setImage:[UIImage imageNamed:kPauseImageName] forState:UIControlStateNormal];
            [self.audioPlayer play];
        } else {
            [self.playButton setImage:[UIImage imageNamed:kPlayImageName] forState:UIControlStateNormal];
        }
    } else {
        NSLog(@"handle error");
    }
}

- (IBAction)playButtonPressed:(UIButton *)sender {
    if ([sender.currentImage isEqual:[UIImage imageNamed:kPlayImageName]]) {
        NSLog(@"played the song");
        [self.audioPlayer play];
        [self.playButton setImage:[UIImage imageNamed:kPauseImageName] forState:UIControlStateNormal];
    } else {
        NSLog(@"paused the song");
        [self.audioPlayer pause];
        [self.playButton setImage:[UIImage imageNamed:kPlayImageName] forState:UIControlStateNormal];
    }
}



@end
