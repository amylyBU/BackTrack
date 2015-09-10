//
//  UIFont+NMAFonts.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/8/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "UIFont+NMAFonts.h"

@implementation UIFont (NMAFonts)

+ (UIFont *)nma_proximaNovaLightWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"ProximaNova-Light" size:fontSize];
}

+ (UIFont *)nma_proximaNovaRegularWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
}

+ (UIFont *)nma_proximaNovaSemiBoldWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"ProximaNova-Semibold" size:fontSize];
}

+ (UIFont *)nma_proximaNovaExtraBoldWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"ProximaNova-Extrabld" size:fontSize];
}
    
+ (UIFont *)nma_proximaNovaBoldWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"ProximaNova-Bold" size:fontSize];
}

@end
