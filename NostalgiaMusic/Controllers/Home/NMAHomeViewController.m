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

- (void)displayContentController:(UIViewController *)content {
    [self ip_addChildViewController:content];
}


#pragma mark - NMAYearCollectionViewControllerDelegate
- (void)didSelectYear:(NSString *)year {
    if (![self.selectedYear isEqualToString:year]) {
        self.selectedYear = year;
        [self.yearActivityScrollVC setUpScrollView:year];
        [self configureLoadingAnimation];
        [self.yearActivityScrollVC setUpPlayerForTableCell];
    }
}

- (void)configureLoadingAnimation {
    
    // an array of animations to perform sequentially
    NSMutableArray *animationBlocks = [[NSMutableArray alloc] init];
    
    CGFloat x = self.view.bounds.origin.x;
    CGFloat y = self.view.bounds.origin.y; // top left corner of activity scroll view (under scroll bar)
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    UIView *blackoutView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    blackoutView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    
    UIImage *ufoImage = [UIImage NMA_ufo];
    
    UIImageView *ufoImageView = [[UIImageView alloc] initWithImage:ufoImage];
    ufoImageView.center = CGPointMake(width, height/2); // want this to be in the center
    ufoImageView.alpha = 1.0;
    [blackoutView addSubview:ufoImageView];
    
    [self.yearActivityScrollVC.view addSubview:blackoutView];
    
    typedef void (^animationBlock)(BOOL);
    
    animationBlock (^getNextAnimation)() = ^{
        animationBlock block = (animationBlock)[animationBlocks firstObject];
        if (block) {
            [animationBlocks removeObjectAtIndex:0];
            return block;
        } else {
            return ^(BOOL finished){};
        }
    };
    
    [animationBlocks addObject:^(BOOL finished) {
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             CGRect comeInFromRight = ufoImageView.frame;
                             comeInFromRight.origin.x -= width/2; // fix magic number
                             ufoImageView.frame = comeInFromRight;
                         }
                         completion:^(BOOL finished) {
                             getNextAnimation()(YES);
                         }
         ];
    }];
    
    [animationBlocks addObject:^(BOOL finished) {
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             CGRect upMovement = ufoImageView.frame;
                             upMovement.origin.y -= 225; // fix magic number
                             upMovement.origin.x -= 0;
                             ufoImageView.frame = upMovement;
                         }
                         completion:^(BOOL finished){
                             [ufoImageView removeFromSuperview];
                             [blackoutView removeFromSuperview];
                             getNextAnimation()(YES);
                         }
         ];
    }];
    
    [animationBlocks addObject:^(BOOL finished) {
        NSLog(@"Multi-step animation complete!");
    }];
    
    getNextAnimation()(YES);
}

#pragma mark - NMAYearCollectionViewControllerDelegate
- (void)updateScrollYear:(NSString *)year {
    [self.yearScrollBarCollectionVC moveToYear:year];
}

@end
