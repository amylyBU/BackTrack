//
//  NMAYearScrollView.h
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/29/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMAContentTableViewController.h"
#import "NMAYearActivityScrollDelegate.h"
#import "NMATodaysSongTableViewCell.h"

@interface NMAYearActivityScrollViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (copy, nonatomic) NSString *year;
@property (weak, nonatomic) id <NMAYearActivityScrollDelegate> delegate;
@property (strong, nonatomic) CABasicAnimation *rotation;

- (void)setUpScrollView:(NSString *)year;
- (NSString *)visibleYear;
- (CALayer *)visibleAlbumImageViewLayer;
- (NMATodaysSongTableViewCell *)visibleSongCell;
- (NMAContentTableViewController *)visibleContentTableVC;
- (void)setUpPlayerForTableCell;
- (void)makeAnimation;
- (void)resumeAnimationLayer;
- (void)pauseAnimationLayer;

@end
