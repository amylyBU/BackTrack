//
//  NMAFBSectionHeader.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/13/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMASectionHeader.h"
#import "UIFont+NMAFonts.h"

@implementation NMASectionHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.headerLabel.font = [UIFont NMA_proximaNovaRegularWithSize:20.0f];
    self.headerLabel.textColor = [UIColor whiteColor];
}

@end
