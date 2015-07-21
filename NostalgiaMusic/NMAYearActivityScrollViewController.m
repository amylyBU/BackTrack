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
@property (strong, nonatomic) CABasicAnimation *rotation;


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

    NSLog(@"Set up resume and pause notifications");

    // Observes when the user resumes the song
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidResumeAVPlayer:)
                                                 name:@"resumeAVPlayerNotification"
                                               object:[NMAPlaybackManager sharedPlayer]];

    // Observes when the user pauses song
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidPauseAVPlayer:)
                                                 name:@"pauseAVPlayerNotification"
                                               object:[NMAPlaybackManager sharedPlayer]];

}

#pragma mark - KVO Notification Handling

- (void)userDidResumeAVPlayer:(NSNotification *)notification {
    [self resumeAnimationLayer];
}

- (void)userDidPauseAVPlayer:(NSNotification *)notification { // this gets called before audioDidFinishPlaying
    [self pauseAnimationLayer];
}

- (void)setUpScrollView:(NSString *)year {
    isEarliestYearVisble = NO;
    isMostRecentYearVisible = NO;
    NSInteger numberOfViews = 3;
    self.year = year;

    if ([self.year isEqualToString:self.earliestYear]) {
        self.year = [self incrementStringValue:self.earliestYear];
        isEarliestYearVisble = YES;
        CGPoint scrollPoint = CGPointMake(0, 0);
        [self.scrollView setContentOffset:scrollPoint animated:NO];
    } else if ([self.year isEqualToString:self.latestYear]) {
        self.year = [self decrementStringValue:self.latestYear];
        isMostRecentYearVisible = YES;
        CGPoint scrollPoint = CGPointMake(self.view.frame.size.width * 2, 0);
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

    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * numberOfViews, self.view.frame.size.height);

    [self setUpPlayerForTableCell];
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
    } else if (fabsf(self.swipeContentOffset - self.scrollView.contentOffset.x) == self.middleTableViewController.view.frame.size.width) {
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
    [[self visibleAlbumImageViewLayer] removeAllAnimations];
    [self setUpPlayerForTableCell];

}

- (void)didSwipeToNextYear {
    if ([self.rightTableViewController.year isEqualToString:self.latestYear]) {
        isMostRecentYearVisible = YES;
        [self.delegate updateScrollYear:[self incrementStringValue:self.year]];
    } else if ([self.leftTableViewController.year isEqualToString:self.earliestYear ] && isEarliestYearVisble) {
        isEarliestYearVisble = NO;
        [self.delegate updateScrollYear:self.year];
    } else {
        [self updatePositioningForScrollPosition:NMAScrollViewPositionNextYear];
    }
    [[self visibleAlbumImageViewLayer] removeAllAnimations];
    [self setUpPlayerForTableCell];
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
    CGFloat origin = position * self.view.frame.size.width;
    viewController.year = year;
    [viewController.view setFrame:CGRectMake(origin, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    //viewController.view.layer.borderColor = [UIColor redColor].CGColor;
    //viewController.view.layer.borderWidth = 10;
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
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy"];
    NSString *currentYear = [DateFormatter  stringFromDate:[NSDate date]];
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

- (void)setUpPlayerForTableCell {
    [[NMAPlaybackManager sharedPlayer] pausePlaying]; // pause the current song before setting up for new year

    [[NMARequestManager sharedManager] getSongFromYear:[self visibleYear]
                                               success:^(NMASong *song) {
                                                   [[self visibleContentTableVC].billboardSongs removeAllObjects];
                                                   [[self visibleContentTableVC].billboardSongs addObject:song];
                                                   [[self visibleContentTableVC].tableView reloadData]; // this would reload the table view with the new song cell. must be done before adding the animation to the album view in the song cell.

                                                   [[NMAPlaybackManager sharedPlayer] setUpAVPlayerWithURL:[NSURL URLWithString:song.previewURL]];
                                                   NSLog(@"Set up songDidEnd observation");
                                                   // Observes when the song finishes playing
                                                   [[NSNotificationCenter defaultCenter] addObserver:self
                                                                                            selector:@selector(audioDidFinishPlaying:)
                                                                                                name:AVPlayerItemDidPlayToEndTimeNotification
                                                                                              object:[NMAPlaybackManager sharedPlayer].audioPlayerItem];
                                                   [self makeAnimation];
                                                   [self resumeAnimationLayer];
                                               }
                                               failure:^(NSError *error) {
                                                   NSLog(@"Something went horribly wrong"); //TODO: handle error
                                               }];
}


#pragma mark - Animation Methods

- (void)pauseAnimationLayer {
    NSLog(@"Pausing animation for year %@", [self visibleYear]);
    CALayer *layer = [self visibleAlbumImageViewLayer];
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeAnimationLayer {
    if ([self visibleAlbumImageViewLayer]) {
        NSLog(@"you called resumeAnimationLayer");
        if ([[NMAAppSettings sharedSettings] userDidAutoplay])  {
            if (![NMAPlaybackManager sharedPlayer].audioPlayer.rate) { // if the song is NOT playing
                NSLog(@"the song currently not playing, so play the song for year %@", [self visibleYear]);
                [[NMAPlaybackManager sharedPlayer] startPlaying]; // when you resume the animation layer, you want to start playing the song. startplaying calls this method again, but next time, the rate will be > 0, (song is playing) so this if statement wont be executed the 2nd time
                return;
            }
        }
        if (![self visibleAlbumImageViewLayer].animationKeys) {
            // if there is no animation key added to the visible layer, then you want to add it depending on whether the song is playing or not
            NSLog(@"animation is not present...");
            if ([NMAPlaybackManager sharedPlayer].audioPlayer.rate) {
                // the song is playing, and there wasn't any animations (like you checked before) so add the animation
                NSLog(@"...and the song is playing, so ADD animation for year %@", [self visibleYear]);
                [[self visibleAlbumImageViewLayer] addAnimation:self.rotation forKey:@"rotationAnimation"];
            } else {
                NSLog(@"...and the song isn't playing, so don't add the animation for year %@", [self visibleYear]);
                // else there is no animation, but the song is not playing yet. do not add the animation.
            }
        } else { // there is an animation layer, you want to resume it at RESUMEANIMATIONLAYER
            NSLog(@"Animation present, RESUME ANIMATION for year %@.", [self visibleYear]);
            CALayer *layer = [self visibleAlbumImageViewLayer];
            CFTimeInterval startTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
            CFTimeInterval pausedTime = [layer timeOffset];
            layer.speed = 1.0;
            layer.timeOffset = 0.0;
            layer.beginTime = 0.0;
            CFTimeInterval timeSincePause = startTime - pausedTime;
            layer.beginTime = timeSincePause;
        }
    }
}

- (void)makeAnimation {
    self.rotation = [[CABasicAnimation alloc] init];
    self.rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    self.rotation.toValue = [NSNumber numberWithFloat:M_PI*2];
    self.rotation.duration = 10;
    self.rotation.cumulative = YES;
    self.rotation.repeatCount = HUGE_VALF;
    self.rotation.removedOnCompletion = NO;
    self.rotation.fillMode = kCAFillModeForwards;
    NSLog(@"Made animation");
}

#pragma mark - Song End Notification Handler

- (void)audioDidFinishPlaying:(NSNotification *)notification {
    // this gets called twice - when the audio finishes playing, and because it has finished playing, the rate is zero and it is "paused"
    NSLog(@"Audio finished playing for year %@, change play button", self.year);
    [[self visibleSongCell] changePlayButtonImageToPlay];
    NSLog(@"Set up songDidEnd notification for latter times");
    // Observes when the song finishes playing
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[NMAPlaybackManager sharedPlayer].audioPlayerItem];
}

@end
