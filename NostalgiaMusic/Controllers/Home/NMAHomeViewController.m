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
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    self.scroll = [[NMAYearCollectionViewController alloc] initWithCollectionViewLayout:flow];
    self.scroll.delegate = self;
    [self displayContentController:self.scroll];
    self.scrollView = [[NMAYearActivityScrollViewController alloc] init];
    self.scrollView.delegate = self;
    [self displayContentTable:self.scrollView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)displayContentController: (UIViewController*) content {
    [self addChildViewController:content];
    CGRect scrollFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40);
    content.view.frame = scrollFrame;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (void)displayContentTable:(UIViewController*) content {
    [self addChildViewController:content];
    CGRect scrollFrame = CGRectMake(0, 40, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    content.view.frame = scrollFrame;
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
