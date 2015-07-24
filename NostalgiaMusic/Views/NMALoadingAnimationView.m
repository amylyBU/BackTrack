//
//  NMALoadingAnimationImageView.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMALoadingAnimationView.h"
#import "UIView+Constraints.h"

@implementation NMALoadingAnimationView

- (void)animateLoadingOverlay {
    
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.80];
    self.cloudsImageView.alpha = 0.0;
    self.ufoLightsImageView.hidden = YES;
    
    CALayer *maskView = [CALayer new];
    maskView.backgroundColor = [UIColor greenColor].CGColor;
    maskView.frame = self.ufoLightsImageView.bounds;
    CGRect frame = maskView.frame;
    frame.origin.y -= CGRectGetHeight(frame);
    maskView.frame = frame;
    self.ufoLightsImageView.layer.mask = maskView;
    
    NSMutableArray *animationBlocks = [[NSMutableArray alloc] init];
    typedef void (^animationBlock)(BOOL);
    
    animationBlock (^getNextAnimation)() = ^{
        animationBlock block = (animationBlock)[animationBlocks firstObject];
        if (block) {
            [animationBlocks removeObjectAtIndex:0];
            return block;
        } else {
            return ^(BOOL finished){};
        }
    };
    
    // ufo coming in from the right
    [animationBlocks addObject:^(BOOL finished) {
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             CGRect comeInFromRight = self.ufoImageView.frame;
                             comeInFromRight.origin.x -= CGRectGetWidth(self.frame)/2;
                             self.ufoImageView.frame = comeInFromRight;
                             
                             self.centerVerticalUfoConstraint.priority = 999;
                             self.topUfoConstraint.priority = 1;
                         }
                         completion:^(BOOL finished) {
                             [self layoutIfNeeded]; // Ensures that all pending layout operations have been completed
                             getNextAnimation()(YES);
                         }
         ];
    }];
    
    // move the ufo up
    [animationBlocks addObject:^(BOOL finished) {
        [UIView animateWithDuration:0.7
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             // Make all constraint changes here
                             self.centerVerticalUfoConstraint.priority = 1;
                             self.topUfoConstraint.priority = 999;
                             [self layoutIfNeeded]; // Forces the layout of the subtree animation block then captures all of the frame changes
                             
//                             CGRect upMovement = self.ufoImageView.frame;
//                             upMovement.origin.x -= 0;
//                             upMovement.origin.y -= CGRectGetHeight(self.frame)/2;
//                             self.ufoImageView.frame = upMovement;
                         }
                         completion:^(BOOL finished){
                             getNextAnimation()(YES);
                         }
         ];
    }];
    
    // mask the ufo lights
    [animationBlocks addObject:^(BOOL finished) {
        [UIView animateWithDuration:2.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             self.ufoLightsImageView.hidden = NO;
                             maskView.frame = self.ufoLightsImageView.bounds; // mask the ufo lights
                         }
                         completion:^(BOOL finished) {
                             getNextAnimation()(YES);
                         }];
    }];
    
    // fade in the clouds
    [animationBlocks addObject:^(BOOL finished) {
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.cloudsImageView.alpha = 1.0f;
                         }
                         completion:^(BOOL finished) {
                             getNextAnimation()(YES);
                         }];
    }];
    
    //remove the superview
    [animationBlocks addObject:^(BOOL finished) {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{}
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             getNextAnimation()(YES);
                         }];
    }];
    
    [animationBlocks addObject:^(BOOL finished) {
        NSLog(@"Multi-step animation complete!");
    }];
    [self layoutIfNeeded]; // Ensures that all pending
    getNextAnimation()(YES);
}

- (void)updateConstraints {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [super updateConstraints];
}

@end
