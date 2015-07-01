//
//  NMAHomeViewController.m
//  NostalgiaMusic
//
//  Created by Bryan Weber on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAHomeViewController.h"
#import "NMASettingsViewController.h"
#import "NMAYearCollectionViewController.h"
#import "NMAContentTableViewController.h"
#import "NMAYearActivityScrollViewController.h"
#import "NMAYearActivityScrollDelegate.h"


@interface NMAHomeViewController () <NMAYearCollectionViewControllerDelegate, NMAYearActivityScrollViewControllerDelegate>
@property (copy, nonatomic) NSString *selectedYear;
@property (strong, nonatomic) NMAYearActivityScrollViewController *yearActivityScrollVC;
@property (strong, nonatomic) NMAYearCollectionViewController *yearScrollBarCollectionVC;
@end

@implementation NMAHomeViewController

- (IBAction)goToSettings:(UIButton *)sender {
    NMASettingsViewController *settingsVC = [NMASettingsViewController new];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)viewDidLoad{
    [self setUpHomeView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)setUpHomeView {
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    self.yearScrollBarCollectionVC = [[NMAYearCollectionViewController alloc] initWithCollectionViewLayout:flow];
    self.yearScrollBarCollectionVC.delegate = self;
    CGRect scrollFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)/15);
    [self displayContentController:self.yearScrollBarCollectionVC frame:scrollFrame];
    self.yearActivityScrollVC = [[NMAYearActivityScrollViewController alloc] init];
    self.yearActivityScrollVC.delegate = self;
    CGRect activityFrame = CGRectMake(0, CGRectGetHeight(self.view.frame)/15, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self displayContentController:self.yearActivityScrollVC frame:activityFrame];
    
}

- (void)displayContentController:(UIViewController*)content frame:(CGRect)contentFrame {
    [self addChildViewController:content];
    content.view.frame = contentFrame;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}


#pragma mark - NMAYearCollectionViewControllerDelegate
- (void)didSelectYear:(NSString *)year {
    self.selectedYear = year;
    [self.yearActivityScrollVC setUpScrollView:year];
}

#pragma mark - NMAActivityScrollDelegate
- (void)updateScrollYear:(NSString *)year {
    [self.yearScrollBarCollectionVC moveToYear:year];
}

@end
