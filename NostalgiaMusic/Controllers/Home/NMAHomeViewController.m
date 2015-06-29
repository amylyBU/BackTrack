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
@property (copy, nonatomic) NSString *selectedYear;
@property (strong, nonatomic) NMAContentTableViewController *tableContent;
@end

@implementation NMAHomeViewController

- (IBAction)goToSettings:(UIButton *)sender {
    NMASettingsViewController *settingsVC = [NMASettingsViewController new];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)viewDidLoad{
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    NMAYearCollectionViewController *scroll = [[NMAYearCollectionViewController alloc] initWithCollectionViewLayout:flow];
    scroll.delegate = self;
    [self displayContentController:scroll];
    self.tableContent =[[NMAContentTableViewController alloc]init];
    self.tableContent.year = @"2014";
    [self displayContentTable:self.tableContent];
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
    self.tableContent.year = year;  
}

@end
