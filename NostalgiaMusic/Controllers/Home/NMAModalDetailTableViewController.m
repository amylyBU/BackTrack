//
//  NMAModalDetailTableViewController.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/20/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAModalDetailTableViewController.h"
#import "UIColor+NMAColors.h"
#import <Social/Social.h>

@interface NMAModalDetailTableViewController()

@property (nonatomic) CGFloat pictureWidth;

@end

@implementation NMAModalDetailTableViewController

static NSString * const kNMAHasFBActivityCellIdentifier = @"NMAFacebookCell";
static CGFloat const kEstimatedRowHeight = 30;

#pragma mark - Init

- (instancetype)initWithActivity:(NMAFBActivity *)fbActivity withWidth:(CGFloat)pictureWidth {
    self = [super init];
    if (self) {
        _fbActivity = fbActivity;
        _pictureWidth = pictureWidth;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)setUpTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMAFBActivityTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kNMAHasFBActivityCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = kEstimatedRowHeight;
    self.tableView.backgroundColor = [UIColor nma_darkOverlay];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NMAFBActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNMAHasFBActivityCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.backgroundColor = [UIColor clearColor];
    [cell configureCellWithActivity:self.fbActivity collapsed:NO withShadow:NO];
    [cell setImageWidth:self.pictureWidth trueAspectRatio:YES withActivity:self.fbActivity];
    [cell layoutIfNeeded];
    return cell;
}

#pragma mark - NMAFBActivityCellDelegate

- (void)shareItems:(NSMutableArray *)itemsToShare {
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void)closeModalDialog {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)loadMoreComments:(NSInteger)addRate currentCount:(NSInteger)currentCount {
    NSIndexPath *modalCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NMAFBActivityTableViewCell *fbCell = (NMAFBActivityTableViewCell *)[self.tableView cellForRowAtIndexPath:modalCellIndexPath];
    [fbCell updateCommentThread:self.fbActivity];
    [self.tableView reloadData];
}

@end
