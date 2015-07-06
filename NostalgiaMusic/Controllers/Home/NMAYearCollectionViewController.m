//
//  NMAYearCollectionViewController.m
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/25/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAYearCollectionViewController.h"
#import "NMAYearCollectionViewCell.h"

static NSInteger const earliestYear = 1981;
static NSString * const kNMAYearCollectionCellIdentifier = @"NMAYearCollectionCell";

@interface NMAYearCollectionViewController ()
@property (strong, nonatomic) NSMutableArray *years;
@property (nonatomic) NSInteger latestYear;

@end

@implementation NMAYearCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.clipsToBounds = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NMAYearCollectionViewCell class]) bundle:nil]
forCellWithReuseIdentifier:kNMAYearCollectionCellIdentifier];
    [self getLatestYear];
    [self setUpCollectionViewWithLayout];
    [self setUpYears];
}

- (void) getLatestYear {
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy"];
    NSString *currentYear = [DateFormatter  stringFromDate:[NSDate date]];
    NSInteger pastyear = [currentYear integerValue] - 1;
    self.latestYear = pastyear;
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *defaultYear = [NSIndexPath indexPathForItem:33 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:defaultYear atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)setUpCollectionViewWithLayout {
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [self.flowLayout setSectionInset:UIEdgeInsetsMake(0, self.collectionView.frame.size.width / 2, 0, self.collectionView.frame.size.width/ 2)];
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    
}

- (void)setUpYears {
    self.years = [[NSMutableArray alloc] init];
    for(int i = 0; i < (self.latestYear - earliestYear + 1); i++){
        NSString *yearForCell = [NSString stringWithFormat:@"%li", earliestYear + i];
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   NMAYearCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNMAYearCollectionCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSString *year = self.years[indexPath.row];
    cell.year.text = year;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *currentYear = [self.years objectAtIndex:indexPath.row];
    [self.delegate didSelectYear:currentYear];
}

- (void)moveToYear:(NSString *)year {
    if([year integerValue] < 2015 && [year integerValue] > 1980){
    NSInteger indexYear = [self.years indexOfObject:year];
    NSIndexPath *defaultYear = [NSIndexPath indexPathForItem:indexYear inSection:0];
    [self.collectionView scrollToItemAtIndexPath:defaultYear atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

@end
