//
//  NMAYearScrollView.m
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/29/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAYearActivityScrollViewController.h"
#import "NMAContentTableViewController.h"
#import "NMAAppSettings.h"
#import "NMAPlaybackManager.h"
#import "NMARequestManager.h"

typedef NS_ENUM(NSUInteger, NMAScrollViewYearPosition) {
    NMAScrollViewPositionPastYear = 0,
    NMAScrollViewPositionCurrentYear,
    NMAScrollViewPositionNextYear,
};

BOOL isEarliestYearVisble;
BOOL isMostRecentYearVisible;

@interface NMAYearActivityScrollViewController ()

@property (strong, nonatomic) NMAContentTableViewController *leftTableViewController;
@property (strong, nonatomic) NMAContentTableViewController *middleTableViewController;
@property (strong, nonatomic) NMAContentTableViewController *rightTableViewController;
@property (copy, nonatomic) NSString *earliestYear;
@property (copy, nonatomic) NSString *latestYear;
@property (nonatomic) float swipeContentOffset;

@end


@implementation NMAYearActivityScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.earliestYear = @"1981";
    [self getLatestYear];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
}

#pragma mark - Scroll View set up

- (void)setUpScrollView:(NSString *)year {
    isEarliestYearVisble = NO;
    isMostRecentYearVisible = NO;
    NSInteger numberOfViews = 3;
    self.year = year;

    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);

    if ([self.year isEqualToString:self.earliestYear]) {
        self.year = [self incrementStringValue:self.earliestYear];
        isEarliestYearVisble = YES;
        CGPoint scrollPoint = CGPointMake(0, 0);
        [self.scrollView setContentOffset:scrollPoint animated:NO];
    } else if ([self.year isEqualToString:self.latestYear]) {
        self.year = [self decrementStringValue:self.latestYear];
        isMostRecentYearVisible = YES;
        CGPoint scrollPoint = CGPointMake(width * 2, 0);
        [self.scrollView setContentOffset:scrollPoint animated:NO];

    } else {
        [self setContentOffsetToCenter];
    }

    [self destroyViewController:self.leftTableViewController];
    [self destroyViewController:self.middleTableViewController];
    [self destroyViewController:self.rightTableViewController];

    self.leftTableViewController = [[NMAContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self configureNMAContentTableViewController:self.leftTableViewController
                                        withYear:[self decrementStringValue:self.year]
                                      atPosition:NMAScrollViewPositionPastYear];

    self.middleTableViewController = [[NMAContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self configureNMAContentTableViewController:self.middleTableViewController
                                        withYear:self.year
                                      atPosition:NMAScrollViewPositionCurrentYear];

    self.rightTableViewController = [[NMAContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self configureNMAContentTableViewController:self.rightTableViewController
                                        withYear:[self incrementStringValue:self.year]
                                      atPosition:NMAScrollViewPositionNextYear];
    self.scrollView.contentSize = CGSizeMake(width * numberOfViews, height);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.leftTableViewController) {
        [self setUpScrollView:self.latestYear];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.swipeContentOffset = self.scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollingDidEnd];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollingDidEnd];
    }
}

- (void)scrollingDidEnd {
    if (isEarliestYearVisble) {
      self.scrollView.contentOffset.x == CGRectGetWidth(self.view.frame) * 1 ? [self didSwipeToNextYear] : [self didSwipeToPastYear];
    } else if (fabs(self.swipeContentOffset - self.scrollView.contentOffset.x) == self.middleTableViewController.view.frame.size.width) {
      self.scrollView.contentOffset.x == CGRectGetWidth(self.view.frame) * 2 ? [self didSwipeToNextYear] : [self didSwipeToPastYear];
    }
}

- (void)setContentOffsetToCenter {
    CGPoint scrollPoint = CGPointMake(CGRectGetWidth(self.view.frame), 0);
    [self.scrollView setContentOffset:scrollPoint animated:NO];
}

- (void)didSwipeToPastYear {
    if ([self.leftTableViewController.year isEqualToString:self.earliestYear]) {
        isEarliestYearVisble = YES;
        [self.delegate updateScrollYear:[self decrementStringValue:self.year]];
    } else if ([self.middleTableViewController.year isEqualToString:[self decrementStringValue:self.latestYear]] && isMostRecentYearVisible) {
        isMostRecentYearVisible = NO;
        [self.delegate updateScrollYear:self.year];
    } else {
        [self updatePositioningForScrollPosition:NMAScrollViewPositionPastYear];
    }
}

- (void)didSwipeToNextYear {
    if ([self.rightTableViewController.year isEqualToString:self.latestYear]) {
        isMostRecentYearVisible = YES;
        [self.delegate updateScrollYear:[self incrementStringValue:self.year]];
    } else if ([self.leftTableViewController.year isEqualToString:self.earliestYear] && isEarliestYearVisble) {
        isEarliestYearVisble = NO;
        [self.delegate updateScrollYear:self.year];
    } else {
        [self updatePositioningForScrollPosition:NMAScrollViewPositionNextYear];
    }
}

- (void)updatePositioningForScrollPosition:(NMAScrollViewYearPosition)position {
    isEarliestYearVisble = NO;
    isMostRecentYearVisible = NO;

    if (position == NMAScrollViewPositionNextYear) {
        [self destroyViewController:self.leftTableViewController];
        self.leftTableViewController = self.middleTableViewController;
        self.middleTableViewController = self.rightTableViewController;
        NMAContentTableViewController *newYear = [[NMAContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self configureNMAContentTableViewController:newYear
                                            withYear:[self incrementStringValue:self.middleTableViewController.year]
                                          atPosition:NMAScrollViewPositionNextYear];
        self.rightTableViewController = newYear;
        self.year = self.middleTableViewController.year;
    } else {
        [self destroyViewController:self.rightTableViewController];
        self.rightTableViewController = self.middleTableViewController;
        self.middleTableViewController = self.leftTableViewController;
        NMAContentTableViewController *newYear = [[NMAContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self configureNMAContentTableViewController:newYear
                                            withYear:[self decrementStringValue:self.middleTableViewController.year]
                                          atPosition:NMAScrollViewPositionPastYear];
        self.leftTableViewController = newYear;
        self.year = self.middleTableViewController.year;
    }
    [self.delegate updateScrollYear:self.year];
    [self adjustFrameView];
    [self setContentOffsetToCenter];
}

- (void)destroyViewController:(NMAContentTableViewController *)tableView {
    [tableView.view removeFromSuperview];
    [tableView removeFromParentViewController];
}

- (void)adjustFrameView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    self.leftTableViewController.view.frame = CGRectMake(0, 0, width, height);
    self.middleTableViewController.view.frame = CGRectMake(width, 0, width, height);
    self.rightTableViewController.view.frame = CGRectMake(width * 2, 0, width, height);
}

- (void)configureNMAContentTableViewController:(NMAContentTableViewController *)viewController
                                      withYear:(NSString *)year
                                    atPosition:(NMAScrollViewYearPosition)position {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat origin = position * width;
    viewController.year = year;
    [viewController.view setFrame:CGRectMake(origin, 0, width, height)];
    [self.scrollView addSubview:viewController.view];
    [self addChildViewController:viewController];
}

#pragma mark - Year Mutator Methods

- (NSString *)incrementStringValue:(NSString *)value {
    NSInteger nextyear = [value integerValue] + 1;
    return [NSString stringWithFormat:@"%li", (long)nextyear];
}

- (NSString *)decrementStringValue:(NSString *)value {
    NSInteger pastyear = [value integerValue] - 1;
    return [NSString stringWithFormat:@"%li", (long)pastyear];
}

#pragma mark - Year Getter Methods

- (void)getLatestYear {
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *currentYear = [dateFormatter stringFromDate:[NSDate date]];
    NSInteger pastyear = [currentYear integerValue] - 1;
    NSString *pastYearString = [NSString stringWithFormat:@"%li", (long)pastyear];
    self.latestYear = pastYearString;
}

- (NSString *)visibleYear {
    if (isMostRecentYearVisible) {
        return self.latestYear;
    } else if (isEarliestYearVisble) {
        return self.earliestYear;
    } else {
        return self.year;
    }
}

- (NMAContentTableViewController *)visibleContentTableVC {
    for (NMAContentTableViewController *tableVC in self.childViewControllers) {
        NSString *visibleYear = [self visibleYear];
        if ([tableVC.year isEqualToString:visibleYear]) {
            return tableVC;
        }
    }
    return nil;
}

- (NMATodaysSongTableViewCell *)visibleSongCell {
    return (NMATodaysSongTableViewCell *)[[self visibleContentTableVC].tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (CALayer *)visibleAlbumImageViewLayer {
    return [self visibleSongCell].albumImageView.layer;
}

- (void)setUpPlayerForTableCellForYear:(NSString *)year {
    [[NMAPlaybackManager sharedPlayer] pausePlaying];
    [[NMARequestManager sharedManager] getSongFromYear:year
                                               success:^(NMASong *song) {
                                                   NMAContentTableViewController *visibleTableVC = [self visibleContentTableVC];
                                                   [visibleTableVC.billboardSongs removeAllObjects];
                                                   [visibleTableVC.billboardSongs addObject:song];
                                                   [visibleTableVC.tableView reloadData];
                                                   [[NMAPlaybackManager sharedPlayer] setUpAVPlayerWithURL:[NSURL URLWithString:song.previewURL]];
                                                   [[NSNotificationCenter defaultCenter] addObserver:self
                                                                                            selector:@selector(audioDidFinishPlaying:)
                                                                                                name:AVPlayerItemDidPlayToEndTimeNotification
                                                                                              object:[NMAPlaybackManager sharedPlayer].audioPlayerItem];
                                                   if ([[NMAAppSettings sharedSettings] userDidAutoplay]) {
                                                       [[NMAPlaybackManager sharedPlayer] startPlaying];
                                                   }
                                               }
                                               failure:^(NSError *error) {}];
}

#pragma mark - Song End Notification Handler

- (void)audioDidFinishPlaying:(NSNotification *)notification {
    [[self visibleSongCell] changePlayButtonImageToPlay];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[NMAPlaybackManager sharedPlayer].audioPlayerItem];
}

@end
