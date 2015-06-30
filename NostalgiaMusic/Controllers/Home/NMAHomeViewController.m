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
@property (strong, nonatomic) NMAContentTableViewController *tableContent;
@property (strong, nonatomic) NMAYearActivityScrollViewController *scrollView;
@property (strong, nonatomic) NMAYearCollectionViewController *scroll;
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
    self.scroll = [[NMAYearCollectionViewController alloc] initWithCollectionViewLayout:flow];
    self.scroll.delegate = self;
    CGRect scrollFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)/15);
    [self displayContentController:self.scroll frame:scrollFrame];
    self.scrollView = [[NMAYearActivityScrollViewController alloc] init];
    self.scrollView.delegate = self;
    CGRect activityFrame = CGRectMake(0, CGRectGetHeight(self.view.frame)/15, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self displayContentController:self.scrollView frame:activityFrame];
    
}

- (void)displayContentController: (UIViewController*) content frame:(CGRect)contentFrame {
    [self addChildViewController:content];
    content.view.frame = contentFrame;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}


#pragma mark - NMAYearCollectionViewControllerDelegate
- (void)didSelectYear:(NSString *)year {
    self.selectedYear = year;
    [self.scrollView setUpScrollView:year];
}

#pragma mark - NMAActivityScrollDelegate
- (void)updateScrollYear:(NSString *)year {
    [self.scroll moveToYear:year];
}

@end
