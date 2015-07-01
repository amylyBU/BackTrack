//
//  NMAYearScrollView.m
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/29/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAYearActivityScrollViewController.h"
#import "NMAContentTableViewController.h"

@interface NMAYearActivityScrollViewController ()
@property (strong, nonatomic) NMAContentTableViewController *pastYearVC;
@property (strong, nonatomic) NMAContentTableViewController *currentYearVC;
@property (strong, nonatomic) NMAContentTableViewController *nextYearVC;
@end

typedef NS_ENUM(NSUInteger, NMAScrollViewYearPosition) {
    NMAScrollViewPositionPastYear = 0,
    NMAScrollViewPositionCurrentYear,
    NMAScrollViewPositionNextYear,
};

BOOL lastYear;
BOOL firstYear;

@implementation NMAYearActivityScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc]
                         initWithFrame:CGRectMake(0, 0,
                                                  self.view.frame.size.width,
                                                  self.view.frame.size.height)];
    self.scrollView.pagingEnabled = YES;
    [self setUpScrollView:@"2014"];
    [self.view addSubview:self.scrollView];
    
}

- (void)setUpScrollView:(NSString *)year {
    NSInteger numberOfViews = 3;
    self.year = year;
    
    if ([self.year isEqualToString:@"1980"]) {
       self.year = @"1981";
        lastYear = YES;
        CGPoint scrollPoint = CGPointMake(0, 0);
        [self.scrollView setContentOffset:scrollPoint animated:NO];
    } else if ([self.year isEqualToString:@"2014"]) {
        self.year = @"2013";
        firstYear = YES;
        CGPoint scrollPoint = CGPointMake(self.view.frame.size.width * 2, 0);
        [self.scrollView setContentOffset:scrollPoint animated:NO];
    } else {
         [self setContentOffsetToCenter];
    }
    self.pastYearVC = [[NMAContentTableViewController alloc]init];
    [self configureNMAContentTableViewController:self.pastYearVC withYear:[self decrementStringValue:self.year] atPosition:NMAScrollViewPositionPastYear];
    self.currentYearVC = [[NMAContentTableViewController alloc]init];
    [self configureNMAContentTableViewController:self.currentYearVC withYear:self.year atPosition:NMAScrollViewPositionCurrentYear];
   
    self.nextYearVC = [[NMAContentTableViewController alloc]init];
   [self configureNMAContentTableViewController:self.nextYearVC withYear:[self incrementStringValue:self.year] atPosition:NMAScrollViewPositionNextYear];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * numberOfViews,
                                             self.view.frame.size.height);
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollingDidEnd];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollingDidEnd];
    }
}

- (void)scrollingDidEnd {
    NSLog(@"really done");
        if (self.scrollView.contentOffset.x == self.view.frame.size.width * 2) {
            [self pushLeft];
    
        } else {
            [self pushRight];
        }
}

- (void)setContentOffsetToCenter {
    CGPoint scrollPoint = CGPointMake(self.view.frame.size.width * 1, 0);
    [self.scrollView setContentOffset:scrollPoint animated:NO];
}

- (void)pushRight {
    if ([self.pastYearVC.year isEqualToString:@"1980"]){
        lastYear = YES;
    } else if ([self.currentYearVC.year isEqualToString:@"2013"] && firstYear)  {
        NSLog(@"test");
        firstYear = NO;
        
    } else {
          lastYear = NO;
        firstYear = NO;
    self.nextYearVC = self.currentYearVC;
    self.currentYearVC = self.pastYearVC;
    NMAContentTableViewController *newYear = [[NMAContentTableViewController alloc]init];
    [self configureNMAContentTableViewController:newYear withYear:[self decrementStringValue:self.currentYearVC.year] atPosition:NMAScrollViewPositionPastYear];
    self.pastYearVC = newYear;
    self.year = self.currentYearVC.year;
    [self.delegate updateScrollYear:self.year];
    [self adjustFrameView];
    [self setContentOffsetToCenter];
    }
}

- (void)pushLeft {
    if ([self.nextYearVC.year isEqualToString:@"2014"]){
        firstYear = YES;
    } else if ([self.pastYearVC.year isEqualToString:@"1980" ] && lastYear) {
          lastYear = NO;
    } else{
        lastYear = NO;
        firstYear = NO;
    self.pastYearVC = self.currentYearVC;
    self.currentYearVC = self.nextYearVC;
    NMAContentTableViewController *newYear = [[NMAContentTableViewController alloc]init];
       [self configureNMAContentTableViewController:newYear withYear:[self incrementStringValue:self.currentYearVC.year] atPosition:NMAScrollViewPositionNextYear];
    self.nextYearVC = newYear;
    self.year = self.currentYearVC.year;
    [self.delegate updateScrollYear:self.year];
    [self adjustFrameView];
    [self setContentOffsetToCenter];
    }
}


- (void)adjustFrameView {
    self.pastYearVC.view.frame = CGRectMake(NMAScrollViewPositionPastYear, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.currentYearVC.view.frame = CGRectMake(CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.nextYearVC.view.frame = CGRectMake(CGRectGetWidth(self.view.frame) * NMAScrollViewPositionNextYear, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (void)configureNMAContentTableViewController:(NMAContentTableViewController *)viewController withYear:(NSString *)year atPosition:(NMAScrollViewYearPosition)position {
    CGFloat origin = position * self.view.frame.size.width;
    [viewController.view setFrame:CGRectMake(origin, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    viewController.year = year;
    self.scrollView.delegate = self;
    [self.scrollView addSubview:viewController.view];
    [self addChildViewController:viewController];
}

#pragma mark - Helper 

- (NSString *)incrementStringValue:(NSString *)value {
    NSInteger nextyear = [value integerValue] + 1;
    return [NSString stringWithFormat:@"%li", nextyear];
}

- (NSString *)decrementStringValue:(NSString *)value {
    NSInteger pastyear = [value integerValue] - 1;
    return [NSString stringWithFormat:@"%li", pastyear];
}
@end
