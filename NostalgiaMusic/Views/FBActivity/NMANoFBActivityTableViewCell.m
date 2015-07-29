//
//  NMANoFBActivityTableViewCell.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/8/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMANoFBActivityTableViewCell.h"
#import "UIColor+NMAColors.h"
#import "UIFont+NMAFonts.h"

@implementation NMANoFBActivityTableViewCell

static CGFloat const kShadowRadius = 4;
static CGFloat const kShadowOpacity = 0.7f;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    self.messageLabel.textColor = [UIColor NMA_tealGreen];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void) addShadow {
    [self setNeedsLayout];
    
    self.messageView.layer.masksToBounds = NO;
    self.messageView.layer.shadowColor = [UIColor NMA_darkGray].CGColor;
    self.messageView.layer.shadowRadius = kShadowRadius;
    self.messageView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.messageView.layer.shadowOpacity = kShadowOpacity;
}

@end
