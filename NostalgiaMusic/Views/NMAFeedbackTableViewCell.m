//
//  NMAFeedbackTableViewCell.m
//  NostalgiaMusic
//
//  Created by Sara Lieto on 7/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAFeedbackTableViewCell.h"
#import "UIColor+NMAColors.h"
#import "UIFont+NMAFonts.h"

@implementation NMAFeedbackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.feedbackLabel.textColor = [UIColor NMA_black];
    self.feedbackLabel.font = [UIFont NMA_proximaNovaRegularWithSize:16.0f];
}

@end
