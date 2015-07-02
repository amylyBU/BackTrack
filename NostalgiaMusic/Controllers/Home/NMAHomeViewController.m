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
#import "UIView+Constraints.h"
#import "UIViewController+Containment.h"

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
    [super viewDidLoad];
    [self setUpHomeView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)setUpHomeView {
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    self.yearScrollBarCollectionVC = [[NMAYearCollectionViewController alloc] initWithCollectionViewLayout:flow];
    self.yearScrollBarCollectionVC.delegate = self;
    CGRect scrollFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)/15);
    [self displayContentController:self.yearScrollBarCollectionVC frame:scrollFrame];
    
    [self.view constrainView:self.yearScrollBarCollectionVC.view top:0 left:0 bottom:NSNotFound right:0];
    [self.view constrainView:self.yearScrollBarCollectionVC.view toHeight:48];
    
    
    self.yearActivityScrollVC = [[NMAYearActivityScrollViewController alloc] init];
    self.yearActivityScrollVC.delegate = self;
    CGRect activityFrame = CGRectMake(0, CGRectGetHeight(self.view.frame)/15, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self displayContentController:self.yearActivityScrollVC frame:activityFrame];
    
    [self.view constrainView:self.yearActivityScrollVC.view belowView:self.yearScrollBarCollectionVC.view];
    [self.view constrainView:self.yearActivityScrollVC.view top:NSNotFound left:0 bottom:0 right:0];
    
}

- (void)displayContentController:(UIViewController*)content frame:(CGRect)contentFrame {
    [self ip_addChildViewController:content];
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
