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

- (void)configureCellForFBActivity:(NMAFBActivity *)FBActivity {
    _timeLabel.text = FBActivity.timeString;
    _postMessage.text = FBActivity.message;
    [_postMessage sizeToFit];
    _collapseImageConstraint.priority = 1;
    _messageHeightFromBottomConstraint.constant = 46;
    
    //check for image
    if(FBActivity.imagePath) {
        NSURL *imageURL = [NSURL URLWithString:FBActivity.imagePath];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *postImage = [UIImage imageWithData:imageData];
        [self setImageViewDimensions:postImage];
        [_postImageView setImage:postImage];
        [self layoutIfNeeded];
    } else {
        _collapseImageConstraint.priority = 999;
    }
}

- (void)setImageViewDimensions:(UIImage *)targetImage {
    float heightToWidthRatio = targetImage.size.height / targetImage.size.width;
    float newViewHeight = heightToWidthRatio * _postImageView.frame.size.width;
    _imageHeightConstraint.constant = newViewHeight;
}

@end
