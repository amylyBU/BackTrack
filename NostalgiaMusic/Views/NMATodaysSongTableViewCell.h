//
//  NMATodaysSongTableViewCell.h
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/4/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class NMASong;

@interface NMATodaysSongTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *iTunesButton;
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) id <AVAudioPlayerDelegate> delegate;

- (void)configureCellForSong:(NMASong *)song;

@end
