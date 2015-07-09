//
//  NMAFBActivityTableViewCell.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/7/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAFBActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation NMAFBActivityTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellForFBActivity:(NMAFBActivity *)FBPost {
    [self setHiddenElements:NO];
    self.timeLabel.text = FBPost.timeString;
    self.postMessage.text = FBPost.message;
    [self.postMessage sizeToFit];
    self.collapseImageConstraint.priority = 1;
    self.messageHeightFromBottomConstraint.constant = 46;
    
    //check for image
    if(FBPost.picturePath) {
        NSURL *imageURL = [NSURL URLWithString:FBPost.picturePath];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *postImage = [UIImage imageWithData:imageData];
        [self setImageViewDimensions:postImage];
        [self.postImageView setImage:postImage];
        [self layoutIfNeeded];
    } else {
        self.collapseImageConstraint.priority = 999;
    }
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

- (void)setImageViewDimensions:(UIImage *)targetImage {
    float heightToWidthRatio = targetImage.size.height / targetImage.size.width;
    float newViewHeight = heightToWidthRatio * self.postImageView.frame.size.width;
    self.imageHeightConstraint.constant = newViewHeight;
}

@end
