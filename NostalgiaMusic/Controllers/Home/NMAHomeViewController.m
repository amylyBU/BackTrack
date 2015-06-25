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

@interface NMAHomeViewController ()

@end

@implementation NMAHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    NMAYearCollectionViewController *scroll = [[NMAYearCollectionViewController alloc] initWithCollectionViewLayout:flow];
    [self displayContentController:scroll];
}

- (IBAction)goToSettings:(UIButton *)sender {
    [self.navigationController pushViewController:[NMASettingsViewController new] animated:YES];
}

- (void)displayContentController: (UIViewController*) content{
    [self addChildViewController:content];
    CGRect scrollFrame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    content.view.frame = scrollFrame;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}

@end
