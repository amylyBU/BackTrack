//
//  NMATodaysSongTableViewCellDelegate.h
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NMATodaysSongTableViewCellDelegate <NSObject>

- (BOOL)tableViewCellIsInView;
- (void)pauseAudioPlayerOnSwipe;
- (void)playAudioPlayerOnSwipe; // for autoplay users

@end
