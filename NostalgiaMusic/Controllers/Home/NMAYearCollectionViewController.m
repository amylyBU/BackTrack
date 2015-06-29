//
//  NMAYearCollectionViewController.m
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/25/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAYearCollectionViewController.h"
#import "NMAYearCollectionViewCell.h"

static NSInteger const earliestYear = 1980;
static NSInteger const latestYear =  2014;
static NSString * const yearCellIdentifier = @"YearCell";

@interface NMAYearCollectionViewController ()
@property (strong, nonatomic) NSMutableArray *years;

@end

@implementation NMAYearCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.clipsToBounds = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NMAYearCollectionViewCell class]) bundle:nil]
forCellWithReuseIdentifier:yearCellIdentifier];
    self.flow = [[UICollectionViewFlowLayout alloc]init];
    self.flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView setCollectionViewLayout:self.flow];
    [self setUpYears];
    }

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *defaultYear = [NSIndexPath indexPathForItem:34 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:defaultYear atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

-(void)setUpYears{
    self.years = [[NSMutableArray alloc] init];
    for(int i = 0; i < (latestYear - earliestYear + 1); i++){
        NSString *yearForCell = [NSString stringWithFormat:@"%ld", earliestYear + i];
        [self.years addObject:yearForCell];
    }
}

#pragma mark UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.years.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.view.frame)/4, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   NMAYearCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:yearCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSString *year = self.years[indexPath.row];
    cell.year.text = year;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *currentYear = [self.years objectAtIndex:indexPath.row];
    [self.delegate didSelectYear:currentYear];
}


@end
