//
//  NMAYearScrollView.m
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/29/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAYearActivityScrollViewController.h"
#import "NMAContentTableViewController.h"


@implementation NMAYearActivityScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.scrollView = [[UIScrollView alloc]
                         initWithFrame:CGRectMake(0, 0,
                                                  self.view.frame.size.width,
                                                  self.view.frame.size.height)];
    self.scrollView.pagingEnabled = YES;
    self.pastYearVC = [[NMAContentTableViewController alloc]init];
     self.currentYearVC = [[NMAContentTableViewController alloc]init];
     self.nextYearVC = [[NMAContentTableViewController alloc]init];
    [self setUpScrollView:@"2014"];
    CGPoint scrollPoint = CGPointMake(self.view.frame.size.width * 1, 0);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
    [self.view addSubview:self.scrollView];
    
}

- (void)setUpScrollView:(NSString *)year {
    
    NSInteger numberOfViews = 3; //previous year, current year, next year
    self.year = year;
    NSInteger pastyear = [self.year integerValue] - 1;
    NSInteger currentyear = [self.year integerValue];
    NSInteger nextyear = [self.year integerValue] + 1;
    
    // NSArray *colors = @[[UIColor redColor], [UIColor yellowColor], [UIColor greenColor]];
    [self initializeTableViews:0 tableView:self.pastYearVC inputYear:pastyear];
    [self initializeTableViews:1 tableView:self.currentYearVC inputYear:currentyear];
    [self initializeTableViews:2 tableView:self.nextYearVC inputYear:nextyear];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * numberOfViews,
                                             self.view.frame.size.height);
    
}

- (void) initializeTableViews:(int)i tableView:(NMAContentTableViewController *)tableView inputYear:(NSInteger)year{
    CGFloat origin = i * self.view.frame.size.width;
    [tableView.view setFrame:CGRectMake(origin, 0, self.view.frame.size.width, self.view.frame.size.height)];
    tableView.year = [NSString stringWithFormat:@"%li", year];
    self.scrollView.delegate = self;
    [self.scrollView addSubview:tableView.view];
    [self addChildViewController:tableView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollView.contentOffset.x == self.view.frame.size.width * 2) {
        [self didPushLeft];
        
    } else {
        [self didPushRight];
    }
    
}

- (void)didPushRight {
    [self.pastYearVC.view setFrame:(CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height))];
    [self.currentYearVC.view setFrame:(CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, self.view.frame.size.height))];
    CGPoint scrollPoint = CGPointMake(self.view.frame.size.width * 1, 0);
    [self.scrollView setContentOffset:scrollPoint animated:NO];
    NMAContentTableViewController *newYear = [[NMAContentTableViewController alloc]init];
    self.nextYearVC = self.currentYearVC;
    self.currentYearVC = self.pastYearVC;
     NSInteger pastyear = [self.currentYearVC.year integerValue] - 1;
    [self initializeTableViews:0 tableView:newYear inputYear:pastyear];
    self.pastYearVC = newYear;
    self.year = self.currentYearVC.year;
    [self.delegate updateScrollYear:self.year];
}

- (void)didPushLeft {
    [self.nextYearVC.view setFrame:(CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height))];
    [self.currentYearVC.view setFrame:(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))];
    CGPoint scrollPoint = CGPointMake(self.view.frame.size.width * 1, 0);
    [self.scrollView setContentOffset:scrollPoint animated:NO];
    NMAContentTableViewController *newYear = [[NMAContentTableViewController alloc]init];
    self.pastYearVC = self.currentYearVC;
    self.currentYearVC = self.nextYearVC;
    NSInteger nextyear = [self.currentYearVC.year integerValue] + 1;
    [self initializeTableViews:2 tableView:newYear inputYear:nextyear];
    self.nextYearVC = newYear;
     self.year = self.currentYearVC.year;
    [self.delegate updateScrollYear:self.year];
    
}

@end
