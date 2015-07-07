//
//  NMAContentTableViewController.m
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/25/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAContentTableViewController.h"
#import "NMAYearTableViewCell.h"
#import <SVPullToRefresh.h>

static NSString * const kNMAYearTableCellIdentifier = @"NMAYearTableCell";
@interface NMAContentTableViewController ()
@property (strong, nonatomic) NSMutableArray *dateRelatedContent;
@end

@implementation NMAContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMAYearTableViewCell class]) bundle:nil] forCellReuseIdentifier:kNMAYearTableCellIdentifier];
    self.dateRelatedContent = [[NSMutableArray alloc] init];
    __weak NMAContentTableViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateRelatedContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NMAYearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNMAYearTableCellIdentifier forIndexPath:indexPath];
    cell.year.text = [self.dateRelatedContent objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Getters | Setters

- (void)setYear:(NSString *)year {
    _year = year;
    [self.dateRelatedContent removeAllObjects];
    [self.dateRelatedContent addObject:self.year];
    [self.tableView reloadData];

}
@end
