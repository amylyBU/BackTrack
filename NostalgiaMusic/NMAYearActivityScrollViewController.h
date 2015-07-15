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

@interface NMAYearActivityScrollViewController : UIViewController <UIScrollViewDelegate>

- (void)setUpScrollView:(NSString *)year;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (copy, nonatomic) NSString *year;
@property (weak, nonatomic) id <NMAYearActivityScrollDelegate> delegate;

- (NSString *)visibleYear;
- (NMAContentTableViewController *)visibleContentTableVC;

@end
