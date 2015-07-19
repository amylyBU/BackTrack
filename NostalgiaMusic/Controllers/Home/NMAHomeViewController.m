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

static const NSInteger kYearScrollBarCollectionVCHeight = 128;

@interface NMAHomeViewController () <NMAYearCollectionViewControllerDelegate, NMAYearActivityScrollDelegate>

@property (copy, nonatomic) NSString *selectedYear;
@property (strong, nonatomic) NMAYearActivityScrollViewController *yearActivityScrollVC;
@property (strong, nonatomic) NMAYearCollectionViewController *yearScrollBarCollectionVC;

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
    UIImage *buttonImage = [UIImage imageNamed:@"setting-icon.png"];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:buttonImage
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(goToSettings:)];
    [self.navigationItem setRightBarButtonItem:settingsButton];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor NMA_lightTeal];
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor NMA_lightTeal];
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

- (void)displayContentController:(UIViewController*)content {
    [self ip_addChildViewController:content];
}


#pragma mark - NMAYearCollectionViewControllerDelegate
- (void)didSelectYear:(NSString *)year {
    self.selectedYear = year;
    [self.yearActivityScrollVC setUpScrollView:year];
    
    // upon selecting year, you want to
    [[NMAPlaybackManager sharedPlayer] pausePlaying]; // pause the current song
    [self.yearActivityScrollVC setUpPlayerForTableCell]; // set it up for the other song
}

#pragma mark - NMAYearCollectionViewControllerDelegate
- (void)updateScrollYear:(NSString *)year {
    [self.yearScrollBarCollectionVC moveToYear:year];
    
}

@end
