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

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    self.messageLabel.textColor = [UIColor NMA_tealGreen];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

@end
