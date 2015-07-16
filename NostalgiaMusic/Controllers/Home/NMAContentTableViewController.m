//
//  NMAContentTableViewController.m
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/25/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAContentTableViewController.h"
#import "NMAYearTableViewCell.h"
#import "NMATodaysSongTableViewCell.h"
#import "NMASong.h"
#import "NMASectionHeader.h"
#import "NMAFBActivityTableViewCell.h"
#import "NMANoFBActivityTableViewCell.h"
#import "NMAFBActivity.h"
#import <SVPullToRefresh.h>
#import "NMARequestManager.h"
#import "NMAAppSettings.h"
#import "NMANewsStoryTableViewCell.h"
#import "NMAPlaybackManager.h"
#import "UIColor+NMAColors.h"
#import "UIFont+NMAFonts.h"
#import "UIImage+NMAImages.h"

NS_ENUM(NSInteger, NMAYearActivitySectionType) {
    NMASectionTypeBillboardSong,
    NMASectionTypeFacebookActivity,
    NMASectionTypeNYTimesNews
};

static const NSInteger kBillboardSongHeightForRow = 400;
static const NSInteger kNumberOfSections = 3;
static NSString * const kNMASectionHeaderIdentifier = @"NMASectionHeader";
static NSString * const kNMATodaysSongCellIdentifier = @"NMATodaysSongCell";
static NSString * const kNMANewsStoryCellIdentifier = @"NMANewsStoryCell";
static NSString * const kNMAHasFBActivityCellIdentifier = @"NMAFacebookCell";
static NSString * const kNMANoFBActivityCellIdentifier = @"NMANoFacebookCell";

@interface NMAContentTableViewController ()

@property (strong, nonatomic) NSMutableArray *billboardSongs;
@property (strong, nonatomic) NSMutableArray *facebookActivities;
@property (strong, nonatomic) NSMutableArray *NYTimesNews;
@property (strong, nonatomic, readwrite) NMADay *day;
@end

@implementation NMAContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //Song cells
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMATodaysSongTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kNMATodaysSongCellIdentifier];

    //FB cells
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMASectionHeader class]) bundle:nil]
         forCellReuseIdentifier:kNMASectionHeaderIdentifier];
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 75.0;

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
    [dateFormatter setDateFormat:@"ddMM"];
    NSString *currentDayMonth = [dateFormatter stringFromDate:[NSDate date]];

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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[NMAPlaybackManager sharedAudioPlayer].audioPlayerItem];
}

- (void)audioDidFinishPlaying:(NSNotification *)notification {
    [(NMATodaysSongTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] changePlayButtonImage];
}
#pragma mark - Table view data source

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
            return cell;
        }
        case NMASectionTypeFacebookActivity: {
            UITableViewCell *cell;
            if (self.day.fbActivities.count > 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:kNMAHasFBActivityCellIdentifier forIndexPath:indexPath];
                [(NMAFBActivityTableViewCell*)cell configureCellForFBActivity:self.day.fbActivities[indexPath.row]];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:kNMANoFBActivityCellIdentifier forIndexPath:indexPath];
            }
            cell.backgroundColor = [UIColor NMA_lightGray];
            [cell layoutIfNeeded];
            return cell;
        }
        case NMASectionTypeNYTimesNews: {
            NMANewsStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNMANewsStoryCellIdentifier forIndexPath:indexPath];
            [cell configureCellForStory:self.NYTimesNews[indexPath.row]];
            cell.backgroundColor = [UIColor NMA_lightGray];
            return cell;
        }
        default:
            return nil;
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
            return kBillboardSongHeightForRow;
        }
        default:
            return 0;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case NMASectionTypeFacebookActivity: {
            NMASectionHeader *fbSectionHeaderCell = [tableView dequeueReusableCellWithIdentifier:kNMASectionHeaderIdentifier];
            fbSectionHeaderCell.headerLabel.text = @"Facebook Activities";
            fbSectionHeaderCell.headerImageView.image = [UIImage NMA_facebookLabel];
            fbSectionHeaderCell.upperBackgroundView.backgroundColor = [UIColor whiteColor];
            fbSectionHeaderCell.backgroundColor = [UIColor NMA_lightGray];
            [fbSectionHeaderCell sizeToFit];
            return fbSectionHeaderCell;
        }
        case NMASectionTypeNYTimesNews: {
            NMASectionHeader *newsSectionHeaderCell = [tableView dequeueReusableCellWithIdentifier:kNMASectionHeaderIdentifier];
            newsSectionHeaderCell.headerLabel.text = @"News";
            newsSectionHeaderCell.headerImageView.image = [UIImage NMA_newsLabel];
            newsSectionHeaderCell.upperBackgroundView.backgroundColor = [UIColor NMA_lightGray];
            newsSectionHeaderCell.backgroundColor = [UIColor NMA_lightGray];
            [newsSectionHeaderCell sizeToFit];
            return newsSectionHeaderCell;
        }
        default:
            return nil;
    }
}

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

#pragma mark - Public Methods

- (void)setUpPlayerForTableCell {
    [[NMARequestManager sharedManager] getSongFromYear:self.year
                                               success:^(NMASong *song) {
                                                   [self.billboardSongs removeAllObjects];

                                                   [self.billboardSongs addObject:song];

                                                   [[NMAPlaybackManager sharedAudioPlayer] setUpWithURL:[NSURL URLWithString:song.previewURL]];
                                                   if ([[NMAAppSettings sharedSettings] userDidAutoplay]) {
                                                       [[NMAPlaybackManager sharedAudioPlayer] startPlaying];
                                                   }
                                                   [self.tableView reloadData];
                                               }
                                               failure:^(NSError *error) {
                                                   NSLog(@"something went horribly wrong"); //TODO: handle error
                                               }];
}

@end
