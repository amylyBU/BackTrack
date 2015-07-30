//
//  UIImage+NMAImages.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "UIImage+NMAImages.h"

@implementation UIImage (NMAImages)

/* Home */
+ (UIImage *)nma_facebookLabel {
    return [UIImage imageNamed:@"facebook_icon"];
}

+ (UIImage *)nma_newsLabel {
    return [UIImage imageNamed:@"news_icon"];
}

+ (UIImage *)nma_settingsGear {
    return [UIImage imageNamed:@"setting-icon.png"];
}

+ (UIImage *)nma_homeBackground {
    return [UIImage imageNamed:@"body-illustration-bg"];
}

+ (UIImage *)nma_defaultRecord {
    return [UIImage imageNamed:@"default-record"];
}

+ (UIImage *)nma_defaultImage {
    return [UIImage imageNamed:@"default-image"];
}

/* Loading Screen */

+ (UIImage *)nma_ufo {
    return [UIImage imageNamed:@"ufo_2010"];
}

+ (UIImage *)nma_clouds {
    return [UIImage imageNamed:@"clouds"];
}

+ (UIImage *)nma_ufoLight {
    return [UIImage imageNamed:@"light"];
}

@end
