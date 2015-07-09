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
#import "NMAFBActivityTableViewCell.h"
#import "NMANoFBActivityTableViewCell.h"
#import "NMAFBActivity.h"
#import <SVPullToRefresh.h>
#import "NMARequestManager.h"
#import "NMAAppSettings.h"
#import "NMANewsStoryTableViewCell.h"

NS_ENUM(NSInteger, NMAYearActivitySectionType) {
    NMASectionTypeBillboardSong,
    NMASectionTypeFacebookActivity,
    NMASectionTypeNYTimesNews
};

static const NSInteger kBillboardSongHeightForRow = 380;
static const NSInteger kNumberOfSections = 3;
static NSString * const kNMATodaysSongCellIdentifier = @"NMATodaysSongCell";
static NSString * const kNMANewsStoryCellIdentifier = @"NMANewsStoryCell";
static NSString * const kNMAFacebookActivityCellIdentifier = @"NMAFacebookCell";
static NSString * const kNMANoFacebookActivityCellIdentifier = @"NMANoFacebookCell";

@interface NMAContentTableViewController ()

@property (strong, nonatomic) NSMutableArray *billboardSongs;
@property (strong, nonatomic) NSMutableArray *facebookActivities;
@property (strong, nonatomic) NSMutableArray *NYTimesNews;
@property (strong, nonatomic, readwrite) NMADay *day;
@end

@implementation NMAContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMATodaysSongTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kNMATodaysSongCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMAFBActivityTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kNMAFacebookActivityCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMANoFBActivityTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kNMANoFacebookActivityCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMANewsStoryTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kNMANewsStoryCellIdentifier];

    self.billboardSongs = [[NSMutableArray alloc] init];
    self.facebookActivities = [[NSMutableArray alloc] init];
    self.NYTimesNews = [[NSMutableArray alloc] init];

    [[NMARequestManager sharedManager] getSongFromYear:self.year
                                               success:^(NMASong *song) {
                                                   [self.billboardSongs addObject:song];
                                                   
                                                   [self.tableView reloadData];
                                               }
                                               failure:^(NSError *error) {
                                                   NSLog(@"something went horribly wrong"); //TODO: handle error
                                               }];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMM"];
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
            NSUInteger activityCount = self.day.FBActivities.count;
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
            if(self.day.FBActivities.count) {
                cell = [tableView dequeueReusableCellWithIdentifier:kNMAFacebookActivityCellIdentifier forIndexPath:indexPath];
                [(NMAFBActivityTableViewCell*)cell configureCellForFBActivity:self.day.FBActivities[indexPath.row]];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:kNMANoFacebookActivityCellIdentifier forIndexPath:indexPath];
            }
            [cell layoutIfNeeded];
            return cell;
        }

        case NMASectionTypeNYTimesNews: {
            NMANewsStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNMANewsStoryCellIdentifier forIndexPath:indexPath];
            [cell configureCellForStory:self.NYTimesNews[indexPath.row]];
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
            static UITableViewCell *prototypeFBCell = nil;
            prototypeFBCell = [self setAppropriateFBCellAtIndexPath:indexPath];
            [prototypeFBCell layoutIfNeeded];
            CGSize size = [prototypeFBCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size.height + 1;
        }
        case NMASectionTypeNYTimesNews: {
            return kBillboardSongHeightForRow;
        }
        default:
            return 0;
    }
}

- (void)setYear:(NSString *)year {
    _year = year;
    self.day = [[NMADay alloc] initWithYear:self.year];
    self.day.delegate = self;
    [self.tableView reloadData];
}

#pragma mark - NMADayDelegate
- (void)updatedFBActivity {
    NSLog(@"FBActivity Updated");
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case NMASectionTypeBillboardSong:
            return @"Top 100 Billboard Song"; //TODO: Remove this title, it is not in the design.
        case NMASectionTypeFacebookActivity:
            return @"Facebook Activities";
        case NMASectionTypeNYTimesNews:
            return @"News";
        default:
            return @"";
    }
}

#pragma mark - Table Cell Utility
//@discussion while this returns UITableViewCell, it is a FB cell (either NoActivity or not)
- (UITableViewCell *)setAppropriateFBCellAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *prototypeFBCell;
    if(self.day.FBActivities.count) {
        prototypeFBCell = [[[NSBundle mainBundle] loadNibNamed:@"NMAFBActivityTableViewCell" owner:self options:nil] objectAtIndex:0];
        [(NMAFBActivityTableViewCell*)prototypeFBCell configureCellForFBActivity:self.day.FBActivities[indexPath.row]];
    } else {
        prototypeFBCell = [[[NSBundle mainBundle] loadNibNamed:@"NMANoFBActivityTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    return prototypeFBCell;
}

@end
