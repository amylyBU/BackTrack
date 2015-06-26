//
//  NMAContentTableViewController.m
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/25/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAContentTableViewController.h"
#import "NMAYearTableViewCell.h"

@interface NMAContentTableViewController () <UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *contents;

@end

@implementation NMAContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMAYearTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"YearTableCell"];
    self.contents = [[NSMutableArray alloc] init];
    [self.contents addObject:self.year];
    int inputYear = [self.year intValue] - 1;
    NSString *previousYear = [NSString stringWithFormat:@"%d", inputYear];
    [self.contents addObject:previousYear];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NMAYearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YearTableCell" forIndexPath:indexPath];
    NSString *contentYear = self.contents[indexPath.row];
    cell.year.text = contentYear;
    return cell;
}

#pragma mark - Getters | Setters

- (void)setYear:(NSString *)year {
    _year = year;
    [self.tableView reloadData];
}
@end
