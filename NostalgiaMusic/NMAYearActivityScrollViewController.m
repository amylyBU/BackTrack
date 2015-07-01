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
@property (strong, nonatomic) NMAContentTableViewController *leftTableViewController;
@property (strong, nonatomic) NMAContentTableViewController *middleTableViewController;
@property (strong, nonatomic) NMAContentTableViewController *rightTableViewController;
@end

typedef NS_ENUM(NSUInteger, NMAScrollViewYearPosition) {
    NMAScrollViewPositionPastYear = 0,
    NMAScrollViewPositionCurrentYear,
    NMAScrollViewPositionNextYear,
};

BOOL isEarliestYearVisble;
BOOL isMostRecentYearVisible;

@implementation NMAYearActivityScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc]
                         initWithFrame:CGRectMake(0, 0,
                                                  CGRectGetWidth(self.view.frame),
                                                    CGRectGetHeight(self.view.frame))];
    self.scrollView.pagingEnabled = YES;
    [self setUpScrollView:@"2014"];
    [self.view addSubview:self.scrollView];
    
}

- (void)setUpScrollView:(NSString *)year {
    NSInteger numberOfViews = 3;
    self.year = year;
    
    if ([self.year isEqualToString:@"1980"]) {
       self.year = @"1981";
        isEarliestYearVisble = YES;
        CGPoint scrollPoint = CGPointMake(0, 0);
        [self.scrollView setContentOffset:scrollPoint animated:NO];
    } else if ([self.year isEqualToString:@"2014"]) {
        self.year = @"2013";
        isMostRecentYearVisible = YES;
        CGPoint scrollPoint = CGPointMake(self.view.frame.size.width * 2, 0);
        [self.scrollView setContentOffset:scrollPoint animated:NO];
    } else {
         [self setContentOffsetToCenter];
    }
    self.leftTableViewController = [[NMAContentTableViewController alloc]init];
    [self configureNMAContentTableViewController:self.leftTableViewController withYear:[self decrementStringValue:self.year] atPosition:NMAScrollViewPositionPastYear];
    self.middleTableViewController = [[NMAContentTableViewController alloc]init];
    [self configureNMAContentTableViewController:self.middleTableViewController withYear:self.year atPosition:NMAScrollViewPositionCurrentYear];
   
    self.rightTableViewController = [[NMAContentTableViewController alloc]init];
   [self configureNMAContentTableViewController:self.rightTableViewController withYear:[self incrementStringValue:self.year] atPosition:NMAScrollViewPositionNextYear];
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
    if ([self.leftTableViewController.year isEqualToString:@"1980"]){
        isEarliestYearVisble = YES;
    } else if ([self.middleTableViewController.year isEqualToString:@"2013"] && isMostRecentYearVisible)  {
        isMostRecentYearVisible = NO;
    } else {
          isEarliestYearVisble = NO;
        isMostRecentYearVisible = NO;
    self.rightTableViewController = self.middleTableViewController;
    self.middleTableViewController = self.leftTableViewController;
    NMAContentTableViewController *newYear = [[NMAContentTableViewController alloc]init];
    [self configureNMAContentTableViewController:newYear withYear:[self decrementStringValue:self.middleTableViewController.year] atPosition:NMAScrollViewPositionPastYear];
    self.leftTableViewController = newYear;
    self.year = self.middleTableViewController.year;
    [self.delegate updateScrollYear:self.year];
    [self adjustFrameView];
    [self setContentOffsetToCenter];
    }
}

- (void)pushLeft {
    if ([self.rightTableViewController.year isEqualToString:@"2014"]){
        isMostRecentYearVisible = YES;
    } else if ([self.leftTableViewController.year isEqualToString:@"1980" ] && isEarliestYearVisble) {
          isEarliestYearVisble = NO;
    } else{
        isEarliestYearVisble = NO;
        isMostRecentYearVisible = NO;
    self.leftTableViewController = self.middleTableViewController;
    self.middleTableViewController = self.rightTableViewController;
    NMAContentTableViewController *newYear = [[NMAContentTableViewController alloc]init];
       [self configureNMAContentTableViewController:newYear withYear:[self incrementStringValue:self.middleTableViewController.year] atPosition:NMAScrollViewPositionNextYear];
    self.rightTableViewController = newYear;
    self.year = self.middleTableViewController.year;
    [self.delegate updateScrollYear:self.year];
    [self adjustFrameView];
    [self setContentOffsetToCenter];
    }
}


- (void)adjustFrameView {
    self.leftTableViewController.view.frame = CGRectMake(NMAScrollViewPositionPastYear, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.middleTableViewController.view.frame = CGRectMake(CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.rightTableViewController.view.frame = CGRectMake(CGRectGetWidth(self.view.frame) * NMAScrollViewPositionNextYear, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
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
