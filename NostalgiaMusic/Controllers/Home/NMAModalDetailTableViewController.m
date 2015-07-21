//
//  NMAModalDetailTableViewController.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/20/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAModalDetailTableViewController.h"
#import "UIColor+NMAColors.h"

@interface NMAModalDetailTableViewController ()

@end

@implementation NMAModalDetailTableViewController

static NSString * const kNMAHasFBActivityCellIdentifier = @"NMAFacebookCell";

#pragma mark - Initializers

- (instancetype)initWithActivity:(NMAFBActivity *)fbActivity {
    
    self = [super init];
    
    if (self) {
        _fbActivity = fbActivity;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMAFBActivityTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kNMAHasFBActivityCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 30.0;
    CGFloat tableViewInset = 56;
    self.tableView.contentInset = UIEdgeInsetsMake(tableViewInset, 0, tableViewInset, 0);
    self.tableView.backgroundColor = [UIColor NMA_darkOverlay];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:kNMAHasFBActivityCellIdentifier forIndexPath:indexPath];
    ((NMAFBActivityTableViewCell *)cell).fbActivity = self.fbActivity;
    ((NMAFBActivityTableViewCell *)cell).delegate = self;
    
    cell.backgroundColor = [UIColor clearColor];
    [(NMAFBActivityTableViewCell *)cell configureCell:NO withShadow:NO];
    [cell layoutIfNeeded];
    
    return cell;
}

#pragma mark - NMAFBActivityCellDelegate

- (void)closeModalDialog {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}


@end
