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

@interface NMAContentTableViewController () <UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *dateRelatedContent;

@end

@implementation NMAContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMAYearTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"YearTableCell"];
    self.dateRelatedContent = [[NSMutableArray alloc] init];
    [self.dateRelatedContent addObject:self.year];
    
    __weak NMAContentTableViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        for (int i = 0; i < 10; i++){
            [weakSelf.dateRelatedContent addObject:@"i"];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        }
        // append data to data source, insert new cells at the end of table view
        // call [tableView.infiniteScrollingView stopAnimating] when done
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
    NMAYearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YearTableCell" forIndexPath:indexPath];
    cell.year.text = [self.dateRelatedContent objectAtIndex:indexPath.row];
    //cell.year.text = self.year;
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
