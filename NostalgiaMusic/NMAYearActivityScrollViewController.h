//
//  NMAYearScrollView.h
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/29/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMAContentTableViewController.h"
#import "NMAYearActivityScrollDelegate.h"

//@interface NMAYearScrollView : UIScrollView
@protocol NMAYearActivityScrollViewControllerDelegate <NSObject>

- (void)updateScrollYear:(NSString *)year;

@end

@interface NMAYearActivityScrollViewController:UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (copy, nonatomic) NSString *year;
@property (strong, nonatomic) NMAContentTableViewController *pastYearVC;
@property (strong, nonatomic) NMAContentTableViewController *currentYearVC;
@property (strong, nonatomic) NMAContentTableViewController *nextYearVC;
@property (weak, nonatomic) id <NMAYearActivityScrollViewControllerDelegate> delegate;

- (void)setUpScrollView:(NSString *)year;

@end
