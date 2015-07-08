//
//  NMAFBActivityTableViewCell.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/7/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAFBActivityTableViewCell.h"

@implementation NMAFBActivityTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellForFBActivity:(NMAFBActivity *)FBPost {
    self.timeLabel.text = FBPost.createdTime;
    self.postMessage.text = FBPost.message;
    NSLog(@"full activity picture height = %f", self.timeView.frame.size.height);
    self.timeViewHeight.constant = 360;
    self.timeView.hidden = NO;
}

- (void)configureEmptyCell {
    self.timeView.hidden = YES;
    self.postImageView.hidden = YES;
    self.postMessage.text = @"There is no Facebook activity from this day";
    NSLog(@"empty activity picture height = %f", self.timeView.frame.size.height);
    [self collapseImage];
}

- (void)collapseImage {
    self.timeViewHeight.constant = 0;
}

@end
