//
//  NMAContentTableViewController.m
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/25/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAModalDetailTableViewController.h"
#import "NMAContentTableViewController.h"
#import "NMAYearTableViewCell.h"
#import "NMATodaysSongTableViewCell.h"
#import "NMASong.h"
#import "NMASectionHeader.h"
#import "NMANoFBActivityTableViewCell.h"
#import "NMAFBActivity.h"
#import <SVPullToRefresh.h>
#import <Social/Social.h>
#import "NMARequestManager.h"
#import "NMAAppSettings.h"
#import "NMANewsStoryTableViewCell.h"
#import "NMAPlaybackManager.h"
#import "UIColor+NMAColors.h"
#import "UIFont+NMAFonts.h"
#import "UIImage+NMAImages.h"
#import "NMAYearActivityScrollViewController.h"
#import "NMATodaysSongTableViewCell.h"

NS_ENUM(NSInteger, NMAYearActivitySectionType) {
    NMASectionTypeBillboardSong,
    NMASectionTypeFacebookActivity,
    NMASectionTypeNYTimesNews
};

static const NSInteger kBillboardSongHeightForRow = 400;
static const NSInteger kNewsStoryHeightForRow = 307;
static const NSInteger kNumberOfSections = 3;
static NSString * const kNMASectionHeaderIdentifier = @"NMASectionHeader";
static NSString * const kNMATodaysSongCellIdentifier = @"NMATodaysSongCell";
static NSString * const kNMANewsStoryCellIdentifier = @"NMANewsStoryCell";
static NSString * const kNMAHasFBActivityCellIdentifier = @"NMAFacebookCell";
static NSString * const kNMANoFBActivityCellIdentifier = @"NMANoFacebookCell";

@interface NMAContentTableViewController ()

@property (strong, nonatomic, readwrite) NMADay *day;
@property (strong, nonatomic) NMAModalDetailTableViewController *modalDetailViewController;

@end

@implementation NMAContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];

    //Song cells
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMATodaysSongTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kNMATodaysSongCellIdentifier];

    //FB cells
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMASectionHeader class]) bundle:nil]
         forCellReuseIdentifier:kNMASectionHeaderIdentifier];
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 100.0;
;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMAFBActivityTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kNMAHasFBActivityCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 30.0;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMANoFBActivityTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kNMANoFBActivityCellIdentifier];

    //Story cells
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMANewsStoryTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kNMANewsStoryCellIdentifier];

    self.billboardSongs = [[NSMutableArray alloc] init];
    self.facebookActivities = [[NSMutableArray alloc] init];
    self.NYTimesNews = [[NSMutableArray alloc] init];

    self.day = [[NMADay alloc] initWithYear:self.year];
    [self.day populateFBActivities:self];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMdd"];
    NSString *currentDayMonth = [dateFormatter  stringFromDate:[NSDate date]];
    NMARequestManager *manager = [[NMARequestManager alloc] init];
    [manager getNewYorkTimesStory:currentDayMonth onYear:self.year
                          success:^(NMANewsStory *story){
                              [self.NYTimesNews addObject:story];
                              [self.tableView reloadData];
                          }
                          failure:^(NSError *error) {
                          }];

    __weak NMAContentTableViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)configureUI {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor NMA_white];
    UIImageView *childView = [[UIImageView alloc] initWithImage:[UIImage NMA_homeBackground]];
    self.tableView.backgroundView = childView;
    [self.tableView sizeToFit];
    self.tableView.allowsSelection = NO;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([[cell class] isEqual:[NMATodaysSongTableViewCell class]]) {
//        NSLog(@"Resuming animation for reallocated song cell");
//        NMAYearActivityScrollViewController *parentVC = (NMAYearActivityScrollViewController *)self.parentViewController;
//        [parentVC resumeAnimationLayer];
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case NMASectionTypeBillboardSong:
            return self.billboardSongs.count;
        case NMASectionTypeFacebookActivity: {
            NSUInteger activityCount = self.day.fbActivities.count;
            return activityCount > 0 ? activityCount : 1;
        }
        case NMASectionTypeNYTimesNews:
            return self.NYTimesNews.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case NMASectionTypeBillboardSong: {
           NMATodaysSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNMATodaysSongCellIdentifier forIndexPath:indexPath];
            [cell configureCellForSong:self.billboardSongs[indexPath.row]];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }
        case NMASectionTypeFacebookActivity: {
            UITableViewCell *cell;
            if (self.day.fbActivities.count > 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:kNMAHasFBActivityCellIdentifier forIndexPath:indexPath];
                NMAFBActivity *fbActvity = self.day.fbActivities[indexPath.row];
                ((NMAFBActivityTableViewCell *)cell).fbActivity = fbActvity;
                ((NMAFBActivityTableViewCell *)cell).delegate = self;
                [(NMAFBActivityTableViewCell *)cell configureCell:YES withShadow:YES];
            } else {
                NMANoFBActivityTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:kNMANoFBActivityCellIdentifier forIndexPath:indexPath];
                temp.messageLabel.textColor = [UIColor NMA_turquoise];
                cell = temp;
            }
            cell.backgroundColor = [UIColor clearColor];
            [cell layoutIfNeeded];
            return cell;
        }
        case NMASectionTypeNYTimesNews: {
            NMANewsStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNMANewsStoryCellIdentifier forIndexPath:indexPath];
            [cell configureCellForStory:self.NYTimesNews[indexPath.row]];
            cell.delegate = self;
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case NMASectionTypeFacebookActivity: {
            UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
            if ([selectedCell isKindOfClass:[NMAFBActivityTableViewCell class]]) {
                NMAFBActivity *fbActivity = ((NMAFBActivityTableViewCell *)selectedCell).fbActivity;
                [self addModalDetailForFBActivity:fbActivity];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case NMASectionTypeBillboardSong:
            return kBillboardSongHeightForRow;
        case NMASectionTypeFacebookActivity: {
            return UITableViewAutomaticDimension;
        }
        case NMASectionTypeNYTimesNews: {
            return kNewsStoryHeightForRow;
        }
        default:
            return 0;
    }
}

-(UIView*)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case NMASectionTypeFacebookActivity: {
            NMASectionHeader *fbSectionHeaderCell = [tableView dequeueReusableCellWithIdentifier:kNMASectionHeaderIdentifier];
            fbSectionHeaderCell.headerLabel.text = @"Facebook Activities";
            fbSectionHeaderCell.headerLabel.font = [UIFont NMA_proximaNovaRegularWithSize:20.0f];
            fbSectionHeaderCell.headerLabel.textColor = [UIColor whiteColor];
            fbSectionHeaderCell.headerImageView.image = [UIImage NMA_facebookLabel];
            fbSectionHeaderCell.upperBackgroundView.backgroundColor = [UIColor whiteColor]; // so the space above the facebook label is white - blends in with the song cell background
            fbSectionHeaderCell.backgroundColor = [UIColor clearColor];
            [fbSectionHeaderCell sizeToFit];
            return fbSectionHeaderCell;
        }
        case NMASectionTypeNYTimesNews: {
            NMASectionHeader *newsSectionHeaderCell = [tableView dequeueReusableCellWithIdentifier:kNMASectionHeaderIdentifier];
            newsSectionHeaderCell.headerLabel.text = @"News";
            newsSectionHeaderCell.headerLabel.font = [UIFont NMA_proximaNovaRegularWithSize:20.0f];
            newsSectionHeaderCell.headerLabel.textColor = [UIColor whiteColor];
            newsSectionHeaderCell.headerImageView.image = [UIImage NMA_newsLabel];
            newsSectionHeaderCell.upperBackgroundView.backgroundColor = [UIColor clearColor];
            newsSectionHeaderCell.backgroundColor = [UIColor clearColor];
            [newsSectionHeaderCell sizeToFit];
            return newsSectionHeaderCell;
        }
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case (NMASectionTypeBillboardSong):
            return 0.0;
        default:
            return 62.0;
    }
}

#pragma mark - Setter Methods

- (void)setYear:(NSString *)year {
    _year = year;
    self.day = [[NMADay alloc] initWithYear:self.year];
    [self.day populateFBActivities:self];
    [self.tableView reloadData];
}

#pragma mark - NMADayDelegate

- (void)allFbActivityUpdate {
    [self.tableView reloadData];
}

- (void)fbActivityDidUpdate:(NMAFBActivity *)activity {
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case NMASectionTypeFacebookActivity:
            return @"Facebook Activities";
        case NMASectionTypeNYTimesNews:
            return @"News";
        default:
            return @"";
    }
}


#pragma mark - Private Utility

- (void)addModalDetailForFBActivity:(NMAFBActivity *)fbActivity {
    self.modalDetailViewController = [[NMAModalDetailTableViewController alloc] initWithActivity:fbActivity];
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];

    [rootViewController.view addSubview:self.modalDetailViewController.view];
    self.modalDetailViewController.view.frame = rootViewController.view.frame;

    [rootViewController addChildViewController:self.modalDetailViewController];
}


@end
