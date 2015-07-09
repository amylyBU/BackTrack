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

static NSString * const kPlayImageName = @"play image name here";
static NSString * const kPauseImageName = @"pause image name here";

@interface NMATodaysSongTableViewCell () <AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

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
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:previewUrl error:nil];
    self.audioPlayer.numberOfLoops = 1;
    
    if (self.audioPlayer) {
        NSLog(@"successful audioplayer init");
        if ([[NMAAppSettings sharedSettings] userDidAutoplay]) {
            self.playButton.imageView.image = [UIImage imageNamed:kPauseImageName]; // set image to pause
            [self.audioPlayer play]; // autoplay
        } else {
            self.playButton.imageView.image = [UIImage imageNamed:kPlayImageName]; // set image to play
        }
    } else {
        NSLog(@"handle error"); // audio player could not be initialized
    }
}

- (IBAction)playButtonPressed:(UIButton *)sender {
    if (sender.imageView.image == [UIImage imageNamed:kPlayImageName]) {
        [self.audioPlayer play];
        sender.imageView.image = [UIImage imageNamed:kPauseImageName];
    } else {
        [self.audioPlayer pause];
        sender.imageView.image = [UIImage imageNamed:kPlayImageName];
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        self.playButton.imageView.image = [UIImage imageNamed:kPlayImageName];
    }
}
@end
