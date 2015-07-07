//
//  NMATodaysSongTableViewCell.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/4/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMATodaysSongTableViewCell.h"
#import "NMASong.h"
#import <AVFoundation/AVFoundation.h>
#import "NMAAppSettings.h"

@implementation NMATodaysSongTableViewCell

- (void)configureCellForSong:(NMASong *)song {
    self.songTitleLabel.text = song.title;
    self.artistLabel.text = song.artistAsAppearsOnLabel;
    
    NSURL *albumImageUrl = [NSURL URLWithString:song.albumImageUrlsArray[0]];
    self.albumImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:albumImageUrl]];;
    
    self.albumImage.layer.cornerRadius = CGRectGetHeight(self.albumImage.frame) /2;
    self.albumImage.layer.masksToBounds = YES;
}

- (void)setUpMusicPlayerWithUrl:(NSURL *)previewUrl { //TODO: this method is not done / not called anywhere. should be done within configureSongCell method.
    
    NSError *error = [[NSError alloc] init];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:previewUrl error:&error];
    player.numberOfLoops = 1; //TODO: configure autoplay settings
    
    //TODO: initialize player.delegate when the home view controller is initialized
    [player prepareToPlay];
    
    if (player) {
        if ([[NMAAppSettings sharedSettings] userDidAutoplay]) {
            [player play];
        }
    } else {
        NSLog(@"%@",[error description]); //TODO: handle error
    }
}

@end
