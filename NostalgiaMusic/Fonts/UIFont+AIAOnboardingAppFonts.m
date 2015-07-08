//
//  UIFont+AIAOnboardingAppFonts.m
//  Onboarding-iOS
//
//  Created by LuQuan Intrepid on 2/19/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "UIFont+AIAOnboardingAppFonts.h"

@implementation UIFont (AIAOnboardingAppFonts)

+ (UIFont *)aia_proximaNovaLightWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"ProximaNova-Light" size:fontSize];
}

+ (UIFont *)aia_proximaNovaRegularWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
}

+ (UIFont *)aia_proximaNovaSemiboldWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"ProximaNova-Semibold" size:fontSize];
}

@end
