//
//  NMALoadingAnimationImageView.h
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMALoadingAnimationView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *ufoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ufoLightsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cloudsImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerVerticalUfoConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topUfoConstraint;

- (void)animateLoadingOverlay;

@end
