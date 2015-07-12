//
//  NMATodaysSongTableViewCell.h
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/4/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NMASong;

@protocol NMATodaysSongCellDelegate <NSObject>

- (void)changePlayButtonImage;

@end

@interface NMATodaysSongTableViewCell : UITableViewCell <NMATodaysSongCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *iTunesButton;
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) id <AVAudioPlayerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (void)configureCellForSong:(NMASong *)song;

@end
