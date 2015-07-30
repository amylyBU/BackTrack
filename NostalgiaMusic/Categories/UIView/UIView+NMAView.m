//
//  UIView+NMAView.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "UIView+NMAView.h"
#import "UIColor+NMAColors.h"

@implementation UIView (NMAView)

static const CGFloat kShadowRadius = 4;
static const CGFloat kShadowOpacity = 0.7f;

+ (void)nma_AddShadow:(UIView *)targetView {
    targetView.layer.masksToBounds = NO;
    targetView.layer.shadowColor = [UIColor nma_darkGray].CGColor;
    targetView.layer.shadowRadius = kShadowRadius;
    targetView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    targetView.layer.shadowOpacity = kShadowOpacity;
}

@end
