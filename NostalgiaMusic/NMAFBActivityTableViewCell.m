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

- (void)configureCellForFBActivity:(NMAFBActivity *)FBActivity {
    self.timeLabel.text = FBActivity.timeString;
    self.postMessage.text = FBActivity.message;
    self.likesButton.titleLabel.text = [@(FBActivity.likes.count) stringValue];
    self.commentsButton.titleLabel.text = [@(FBActivity.comments.count) stringValue];
    [self.postMessage sizeToFit];
    self.collapseImageConstraint.priority = 1;
    
    //check for image
    if (FBActivity.imagePath) {
        NSURL *imageURL = [NSURL URLWithString:FBActivity.imagePath];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *postImage = [UIImage imageWithData:imageData];
        [self setImageViewDimensions:postImage];
        [self.postImageView setImage:postImage];
        [self layoutIfNeeded];
    } else {
        self.collapseImageConstraint.priority = 999;
    }
}

- (void)setImageViewDimensions:(UIImage *)targetImage {
    float heightToWidthRatio = targetImage.size.height / targetImage.size.width;
    float newViewHeight = heightToWidthRatio * CGRectGetWidth(self.postImageView.frame);
    self.imageHeightConstraint.constant = newViewHeight;
}

@end
