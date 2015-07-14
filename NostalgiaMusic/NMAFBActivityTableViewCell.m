//
//  NMAFBActivityTableViewCell.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/7/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAFBActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+NMAColors.h"
#import "UIFont+NMAFonts.h"

@implementation NMAFBActivityTableViewCell

- (void)awakeFromNib {
    self.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    self.postMessage.textColor = [UIColor NMA_almostBlack];
    [self.likesButton setTitleColor:[UIColor NMA_darkGray] forState:UIControlStateNormal];
    [self.commentsButton setTitleColor:[UIColor NMA_darkGray] forState:UIControlStateNormal];
}

- (void)configureCellForFBActivity:(NMAFBActivity *)FBActivity {
    self.timeLabel.text = FBActivity.timeString;
    self.postMessage.text = FBActivity.message;
    NSString* likeCountText = [@(FBActivity.likes.count) stringValue];
    [self.likesButton setTitle:likeCountText forState:UIControlStateNormal];
    NSString* commentCountText = [@(FBActivity.comments.count) stringValue];
    [self.commentsButton setTitle:commentCountText forState:UIControlStateNormal];
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
    
    //Add a shadow to the bottom of the message view
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.messageView.bounds];
    self.messageView.layer.masksToBounds = NO;
    self.messageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.messageView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.messageView.layer.shadowOpacity = 0.5f;
    self.messageView.layer.shadowPath = shadowPath.CGPath;
}

- (void)setImageViewDimensions:(UIImage *)targetImage {
    float heightToWidthRatio = targetImage.size.height / targetImage.size.width;
    float newViewHeight = heightToWidthRatio * CGRectGetWidth(self.postImageView.frame);
    self.imageHeightConstraint.constant = newViewHeight;
}

@end
