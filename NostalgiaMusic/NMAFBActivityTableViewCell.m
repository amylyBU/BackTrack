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
    [self setHiddenElements:NO];
    self.timeLabel.text = FBPost.createdTime;
    self.postMessage.text = FBPost.message;
    [self.postMessage sizeToFit];
    self.imageHeightConstraint.constant = 300; //TODO: get actual picture size
    self.collapseImageConstraint.priority = 1;
    self.messageHeightFromBottomConstraint.constant = 46;
}

- (void)configureEmptyCell {
    [self setHiddenElements:YES];
    self.postMessage.text = @"There is no Facebook activity from this day";
    [self.postMessage sizeToFit];
    self.collapseImageConstraint.priority = 999;
    self.messageHeightFromBottomConstraint.constant = 20;
}

- (void)setHiddenElements:(BOOL)isHidden {
    self.timeView.hidden = isHidden;
    self.postImageView.hidden = isHidden;
    self.commentsButton.hidden = isHidden;
    self.likesButton.hidden = isHidden;
    self.shareButton.hidden = isHidden;
}

@end
