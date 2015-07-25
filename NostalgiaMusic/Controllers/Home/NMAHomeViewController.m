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
#import "UIColor+NMAColors.h"
#import "UIFont+NMAFonts.h"
#import "UIImage+NMAImages.h"
#import "NMAPlaybackManager.h"
#import "UIView+NibInitable.h"
#import "NMALoadingAnimationView.h"
#import "UIView+Constraints.h"

static const NSInteger kYearScrollBarCollectionVCHeight = 128;

@interface NMAHomeViewController () <NMAYearCollectionViewControllerDelegate, NMAYearActivityScrollDelegate>

@property (copy, nonatomic) NSString *selectedYear;
@property (strong, nonatomic) NMAYearActivityScrollViewController *yearActivityScrollVC;
@property (strong, nonatomic) NMAYearCollectionViewController *yearScrollBarCollectionVC;
@property (strong, nonatomic) UIView *blackoutActivityView;

@end


@implementation NMAHomeViewController

- (void)goToSettings:(UIButton *)sender {
    NMASettingsViewController *settingsVC = [NMASettingsViewController new];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUpHomeView];
    [self configureUI];
}

- (void)configureUI {
    self.title = @"";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImage *buttonImage = [UIImage imageNamed:@"setting-icon.png"];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:buttonImage
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(goToSettings:)];
    [self.navigationItem setRightBarButtonItem:settingsButton];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor NMA_lightTeal];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                     NSFontAttributeName:[UIFont NMA_proximaNovaRegularWithSize:20.0f] };
}

- (void)setUpHomeView {
    self.yearScrollBarCollectionVC = [[NMAYearCollectionViewController alloc] init];
    self.yearScrollBarCollectionVC.delegate = self;
    [self displayContentController:self.yearScrollBarCollectionVC];
    
    [self.view constrainView:self.yearScrollBarCollectionVC.view top:0 left:0 bottom:NSNotFound right:0];
    [self.view constrainView:self.yearScrollBarCollectionVC.view toHeight:kYearScrollBarCollectionVCHeight];
    
    self.yearActivityScrollVC = [[NMAYearActivityScrollViewController alloc] init];
    self.yearActivityScrollVC.delegate = self;
   
    [self displayContentController:self.yearActivityScrollVC];
    
    [self.view constrainView:self.yearActivityScrollVC.view belowView:self.yearScrollBarCollectionVC.view];
    [self.view constrainView:self.yearActivityScrollVC.view top:NSNotFound left:0 bottom:0 right:0];
    
}

- (void)displayContentController:(UIViewController *)content {
    [self ip_addChildViewController:content];
}

#pragma mark - NMAYearCollectionViewControllerDelegate

- (void)didSelectYear:(NSString *)year {
    if (![self.selectedYear isEqualToString:year]) {
        self.selectedYear = year;
        [self.yearActivityScrollVC setUpScrollView:year];
        [self configureLoadingAnimationView];
        [self.yearActivityScrollVC setUpPlayerForTableCell];
    }
}

- (void)configureLoadingAnimationView {
    [self.blackoutActivityView removeFromSuperview];
    NMALoadingAnimationView *loadingAnimationView = [[NMALoadingAnimationView alloc] initWithNibNamed:nil];
    loadingAnimationView.delegate = self;
    [self.yearActivityScrollVC.view addSubview:loadingAnimationView];
    [self.yearActivityScrollVC.view constrainView:loadingAnimationView toInsets:UIEdgeInsetsZero];
    [loadingAnimationView animateLoadingOverlay];
    
}

- (void)blackoutActivity {
    int numberOfActivityScrollSubviews = (int)self.yearActivityScrollVC.view.subviews.count;
    if (!(numberOfActivityScrollSubviews == 2)) {
        self.blackoutActivityView = [[UIView alloc] initWithFrame:self.yearActivityScrollVC.view.bounds];
        self.blackoutActivityView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self.yearActivityScrollVC.view addSubview:self.blackoutActivityView];
    }
}

- (void)removeBlackoutFromScrollBar {
    self.navigationController.navigationBar.alpha = 1.0;
    self.yearScrollBarCollectionVC.blackoutNavBarView.hidden = YES;
}

#pragma mark - NMAYearActivityScrollDelegate

- (void)updateScrollYear:(NSString *)year {
    [self.yearScrollBarCollectionVC moveToYear:year];
}

@end
