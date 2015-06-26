//
//  NMAOnboardingViewController.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NMAOnboardingViewControllerDelegate <NSObject>

- (void)userDidSkipOnboarding;

@end

@interface NMAOnboardingViewController : UIViewController

@property (weak, nonatomic) id <NMAOnboardingViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@end
