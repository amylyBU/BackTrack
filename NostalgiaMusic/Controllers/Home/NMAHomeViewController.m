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

@interface NMAHomeViewController () <NMAYearCollectionViewControllerDelegate>
@property (strong, nonatomic) NSString *selectedYear;
@property (strong, nonatomic) NMAContentTableViewController *tableContent;
@end

@implementation NMAHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    NMAYearCollectionViewController *scroll = [[NMAYearCollectionViewController alloc] initWithCollectionViewLayout:flow];
    scroll.delegate = self;
    [self displayContentController:scroll];
    self.tableContent =[[NMAContentTableViewController alloc]init];
    self.tableContent.year = @"2014";
    [self displayContentTable:self.tableContent];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //TODO: fix constraints
}

- (IBAction)goToSettings:(UIButton *)sender {
    [self.navigationController pushViewController:[NMASettingsViewController new] animated:YES];
}

- (void)displayContentController: (UIViewController*) content{
    [self addChildViewController:content];
    CGRect scrollFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50);
    content.view.frame = scrollFrame;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (void)displayContentTable:(UIViewController*) content{
    [self addChildViewController:content];
    CGRect scrollFrame = CGRectMake(0, 50, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    content.view.frame = scrollFrame;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}

#pragma mark - NMAYearCollectionViewControllerDelegate

- (void)didSelectYear:(NSString *)year {
    self.selectedYear = year;
    self.tableContent.year = year;
  
}

@end
