//
//  NMAYearCollectionViewController.m
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/25/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAYearCollectionViewController.h"
#import "NMAYearCollectionViewCell.h"
#import "NMASelectedYearCollectionViewCell.h"
#import <QuartzCore/CALayer.h>
#import "UIColor+NMAColors.h"
#import "UIFont+NMAFonts.h"
#import "UIImage+NMAImages.h"

typedef NS_ENUM(NSUInteger, NMAScrollViewDelegateAction) {
    NMAScrollViewDidScroll,
    NMAScrollViewDidEndGesture,
};

static NSInteger const earliestYear = 1981;
static NSString * const kNMAYearCollectionCellIdentifier = @"NMAYearCollectionCell";
static NSInteger const kNumberOfSectionsInYearCollection = 1;
static NSString * const kNMASelectedYearcollectionViewCellIdentifier = @"NMASelectedYearCollectionViewCell";

@interface NMAYearCollectionViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *years;
@property (nonatomic) NSInteger latestYear;
@property (weak, nonatomic) IBOutlet UIView *whiteYearBackgroundSquare;
@property (strong, nonatomic) UIView *blackoutView;

@end

@implementation NMAYearCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollBarCollectionView.clipsToBounds = YES;
    [self.scrollBarCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NMAYearCollectionViewCell class]) bundle:nil]
                   forCellWithReuseIdentifier:kNMAYearCollectionCellIdentifier];
    [self getLatestYear];
    [self configureUIElements];
    [self setUpCollectionViewWithLayout];
    [self setUpYears];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSInteger test = [self.year integerValue];
    NSInteger yearIndexPath = test - earliestYear;
    if (self.year) {
        NSIndexPath *defaultYear = [NSIndexPath indexPathForItem:yearIndexPath inSection:0];
        [self.scrollBarCollectionView scrollToItemAtIndexPath:defaultYear atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    } else {
        [self.scrollBarCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.years.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}

- (void)configureUIElements {
    self.whiteYearBackgroundSquare.backgroundColor = [UIColor whiteColor];
    [self.whiteYearBackgroundSquare.layer masksToBounds];
    self.whiteYearBackgroundSquare.layer.cornerRadius = 20;
    self.whiteYearBackgroundSquare.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor NMA_lightTeal];
    [self.dateLabel setFont:[UIFont NMA_proximaNovaRegularWithSize:14]];
    self.dateLabel.textColor = [UIColor NMA_darkSkyBlue];
    self.dateLabel.text = [self getDate];
    self.blackoutNavBarView.hidden = YES;
}

- (void)setUpCollectionViewWithLayout {
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [self.flowLayout setSectionInset:UIEdgeInsetsMake(0, CGRectGetWidth(self.scrollBarCollectionView.frame)/2, 0, CGRectGetWidth(self.scrollBarCollectionView.frame)/2)];
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.scrollBarCollectionView setCollectionViewLayout:self.flowLayout];
}

- (void)setUpYears {
    self.years = [[NSMutableArray alloc] init];
    for ( int i = 0; i < (self.latestYear - earliestYear + 1); i++ ){
        NSString *yearForCell = [NSString stringWithFormat:@"%li", (long)(earliestYear + i)];
        [self.years addObject:yearForCell];
    }
}

#pragma mark UICollectionViewDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.parentViewController.navigationItem.rightBarButtonItem.enabled = NO;
    self.parentViewController.navigationController.navigationBar.alpha = 0.2;
    self.blackoutNavBarView.hidden = NO;
    self.blackoutNavBarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.delegate blackoutActivity];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self checkIfWhiteBoxContainsYear:NMAScrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self checkIfWhiteBoxContainsYear:NMAScrollViewDidEndGesture];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self checkIfWhiteBoxContainsYear:NMAScrollViewDidEndGesture];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, self.scrollBarCollectionView.frame.size.width/3, 0,self.scrollBarCollectionView.frame.size.width/3 );
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return kNumberOfSectionsInYearCollection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.years.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.view.frame)/3, 42);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *year = self.years[indexPath.row];
    NMAYearCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNMAYearCollectionCellIdentifier forIndexPath:indexPath];
    cell.year.text = year;
    if ([year isEqualToString:self.year] || ([year isEqualToString:[NSString stringWithFormat:@"%li", (long)self.latestYear]] && self.year == nil)) {
        [self formatMiddleCell:cell isSelected:YES];
        return cell;
    } else {
        [self formatNonMiddlecell:cell];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *currentYear = [self.years objectAtIndex:indexPath.row];
    self.year = currentYear;
    [self.delegate didSelectYear:currentYear];
}

#pragma mark - Helpers

- (void)checkIfWhiteBoxContainsYear:(NSInteger)scroll {
    NSArray *visible = [self.scrollBarCollectionView visibleCells];
    BOOL didFindMiddleCell = NO;
    for (NMAYearCollectionViewCell *cell in visible) {
        CGRect whiteSquareRect = self.whiteYearBackgroundSquare.frame;
        CGRect cellFrameInView = [self convertCellOriginToSuperview:cell];
        CGPoint cellOriginMiddle = CGPointMake (cellFrameInView.origin.x + self.view.frame.size.width/6, cellFrameInView.origin.y);
        switch (scroll) {
            case NMAScrollViewDidEndGesture:
                if (CGRectContainsPoint(whiteSquareRect, cellOriginMiddle)) {
                    [self snapYearOnGesture:cell];
                    didFindMiddleCell = YES;
                } else if (!didFindMiddleCell && [visible indexOfObject:cell] == visible.count -1) {
                    [self snapYearOnGesture:[visible objectAtIndex:1]];
                }
                break;
            default:
                if (CGRectContainsPoint(whiteSquareRect, cellOriginMiddle) && [self.year isEqualToString:cell.year.text]) {
                    [self formatMiddleCell:cell isSelected:YES];
                    didFindMiddleCell = YES;
                    break;
                } else if (CGRectContainsPoint(whiteSquareRect, cellOriginMiddle)) {
                    [self formatMiddleCell:cell isSelected:NO];
                    didFindMiddleCell = YES;
                } else {
                    [self formatNonMiddlecell:cell];
                }
                break;
        }
    }
}

- (CGRect)convertCellOriginToSuperview:(NMAYearCollectionViewCell *)cell {
    CGRect cellRect = cell.frame;
    CGRect cellFrameInView = [self.scrollBarCollectionView convertRect:cellRect toView:[self.scrollBarCollectionView superview]];
    return cellFrameInView;
}

- (void)formatMiddleCell:(NMAYearCollectionViewCell *)cell isSelected:(BOOL)isSelected {
    [cell.year setFont:[UIFont systemFontOfSize:30]];
    [cell.year setFont:[UIFont NMA_proximaNovaExtraBoldWithSize:30]];
    cell.year.textColor = isSelected ? [UIColor NMA_sunYellow] : [UIColor NMA_aquaMarine];
}

- (void)formatNonMiddlecell:(NMAYearCollectionViewCell *)cell {
    [cell.year setFont:[UIFont systemFontOfSize:17]];
    [cell.year setFont:[UIFont NMA_proximaNovaSemiBoldWithSize:17]];
    cell.year.textColor = [UIColor whiteColor];
}

- (void)snapYearOnGesture:(NMAYearCollectionViewCell*)cell {
    [self.scrollBarCollectionView scrollToItemAtIndexPath:[self.scrollBarCollectionView indexPathForCell:cell] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)positionYearAfterYearIsSet {
    NSInteger currentYearAsInt = [self.year integerValue];
    NSInteger yearIndexPath = currentYearAsInt - earliestYear;
    if (self.year) {
        NSIndexPath *defaultYear = [NSIndexPath indexPathForItem:yearIndexPath inSection:0];
        [self.scrollBarCollectionView scrollToItemAtIndexPath:defaultYear atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        NMAYearCollectionViewCell *cell = (NMAYearCollectionViewCell *)[self.scrollBarCollectionView cellForItemAtIndexPath:defaultYear];
        [self formatMiddleCell:cell isSelected:YES];
    } else {
        [self.scrollBarCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.years.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark - Public delegate methods

- (void)moveToYear:(NSString *)year {
    if ([year integerValue] < 2015 && [year integerValue] > 1980) {
        self.year = year;
        NSInteger indexYear = [self.years indexOfObject:year];
        NSIndexPath *defaultYear = [NSIndexPath indexPathForItem:indexYear inSection:0];
        [self.scrollBarCollectionView scrollToItemAtIndexPath:defaultYear atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark - Getters and Setters

- (void)getLatestYear {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *currentYear = [dateFormatter stringFromDate:[NSDate date]];
    NSInteger pastyear = [currentYear integerValue] - 1;
    self.latestYear = pastyear;
}

- (NSString *)getDate {
    NSString *weekday;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"LLLL dd"];
    NSString *displayDateWithMonthAsWord = [dateFormatter  stringFromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"MMdd"];
    NSString *monthAndDay = [dateFormatter stringFromDate:[NSDate date]];
    if (self.year) {
        weekday = [self calculateDayOfWeekWithDate:monthAndDay inYear:self.year];
    } else {
        NSString *latestYearConverted = [NSString stringWithFormat:@"%li", (long)self.latestYear];
        weekday = [self calculateDayOfWeekWithDate:monthAndDay inYear:latestYearConverted];
    }

    NSString *returnDate = [displayDateWithMonthAsWord stringByAppendingString:@" "];
    returnDate = [returnDate stringByAppendingString:weekday];
    return returnDate;
}

- (NSString *)calculateDayOfWeekWithDate:(NSString *)monthAndDay inYear:(NSString *)year {
    NSString *weekday;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *currentDateWithSelectedYear = [monthAndDay stringByAppendingString:year];
    [dateFormatter setDateFormat:@"MMddyyyy"];
    NSDate *testDate = [dateFormatter dateFromString:currentDateWithSelectedYear];
    [dateFormatter setDateFormat:@"EE"];
    weekday = [[dateFormatter stringFromDate:testDate] uppercaseString];
    return weekday;
}

- (void)setYear:(NSString *)year {
    _year = year;
    [self positionYearAfterYearIsSet];
    self.dateLabel.text = [self getDate];
}
@end
