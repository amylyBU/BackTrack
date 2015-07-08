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

static NSString * const kPlayImageName = @"play";
static NSString * const kPauseImageName = @"pause";

@interface NMATodaysSongTableViewCell () <AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) AVPlayer *audioPlayer;

@end

@implementation NMATodaysSongTableViewCell



- (void)configureCellForSong:(NMASong *)song {
    self.delegate = self;
    
    self.songTitleLabel.text = song.title;
    self.artistLabel.text = song.artistAsAppearsOnLabel;
    
    NSURL *albumImageUrl = [NSURL URLWithString:song.albumImageUrlsArray[0]];
    self.albumImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:albumImageUrl]];
    self.albumImage.layer.cornerRadius = CGRectGetHeight(self.albumImage.frame) /2;
    self.albumImage.layer.masksToBounds = YES;
    
    [self setUpMusicPlayerWithUrl:[NSURL URLWithString:song.previewURL]];
}

- (void)setUpMusicPlayerWithUrl:(NSURL *)previewUrl {
    self.audioPlayer = [[AVPlayer alloc] initWithURL:previewUrl];
    
    if (self.audioPlayer) {
        NSLog(@"successful audioplayer init");
        //if ([[NMAAppSettings sharedSettings] userDidAutoplay]) {
        if (NO) {
            self.playButton.imageView.image = [UIImage imageNamed:kPauseImageName]; // set image to pause
            self.playButton.titleLabel.text = @"PAUSE";
            [self.audioPlayer play]; // autoplay
        } else {
            self.playButton.titleLabel.text = @"PLAY";
            self.playButton.imageView.image = [UIImage imageNamed:kPlayImageName]; // set image to play
        }
    } else {
        NSLog(@"handle error");
    }
}

- (IBAction)playButtonPressed:(UIButton *)sender {
    if (sender.imageView.image == [UIImage imageNamed:kPlayImageName]) {
    //if ([sender.titleLabel.text isEqualToString:@"play"]) {
        NSLog(@"played the song");
        [self.audioPlayer play];
        self.playButton.titleLabel.text = @"PAUSE";
        self.playButton.imageView.image = [UIImage imageNamed:kPauseImageName];
    } else {
        NSLog(@"paused the song");
        [self.audioPlayer pause];
        self.playButton.titleLabel.text = @"PLAY";
        self.playButton.imageView.image = [UIImage imageNamed:kPlayImageName];
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        self.playButton.imageView.image = [UIImage imageNamed:kPlayImageName];
    }
}
@end
