//
//  UIFont+NMAFonts.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/8/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "UIFont+NMAFonts.h"

@implementation UIFont (NMAFonts)

+ (UIFont *)NMA_proximaNovaLightWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"ProximaNova-Light" size:fontSize];
}

+ (UIFont *)NMA_proximaNovaRegularWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
}

+ (UIFont *)NMA_proximaNovaSemiBoldWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"ProximaNova-Semibold" size:fontSize];
}

@end
