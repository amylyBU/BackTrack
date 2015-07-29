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
static const NSInteger kHeightOfHeaderBanners = 70;
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

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMAFBActivityTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kNMAHasFBActivityCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 30.0;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMANoFBActivityTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kNMANoFBActivityCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 135.0;

    //Story cells
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMANewsStoryTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kNMANewsStoryCellIdentifier];

    self.billboardSongs = [[NSMutableArray alloc] init];
    self.facebookActivities = [[NSMutableArray alloc] init];
    self.NYTimesNews = [[NSMutableArray alloc] init];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMdd"];
    NSString *currentDayMonth = [dateFormatter stringFromDate:[NSDate date]];
    NMARequestManager *manager = [[NMARequestManager alloc] init];
    [manager getNewYorkTimesStory:currentDayMonth onYear:self.year
                          success:^(NMANewsStory *story) {
                              [self.NYTimesNews addObject:story];
                              if (self.NYTimesNews.count > 0) {
                                  [self.tableView reloadData];
                              }
                          }
                          failure:^(NSError *error) {
                          }];
    
    [self getSongCellForTableVC:self.year];
    
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
    [childView setContentMode:UIViewContentModeBottom|UIViewContentModeCenter];
}

- (void)getSongCellForTableVC:(NSString *)year {
    if (self.billboardSongs.count == 0) {
        [[NMARequestManager sharedManager] getSongFromYear:year success:^(NMASong *song) {
            [self.billboardSongs addObject:song];
            [self.tableView reloadData];
        } failure:^(NSError *error) {}];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case NMASectionTypeBillboardSong:
            return 1;
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
            self.billboardSongs.count > 0 ? [cell configureCellForSong:self.billboardSongs[indexPath.row]] : [cell configureEmptyCell];
            return cell;
        }
        case NMASectionTypeFacebookActivity: {
            UITableViewCell *cell;
            if (self.day.fbActivities.count > 0) {
                NMAFBActivityTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:kNMAHasFBActivityCellIdentifier forIndexPath:indexPath];
                NMAFBActivity *fbActvity = self.day.fbActivities[indexPath.row];
                temp.fbActivity = fbActvity;
                temp.delegate = self;
                [temp configureCell:YES withShadow:YES];
                cell = temp;
            } else {
                NMANoFBActivityTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:kNMANoFBActivityCellIdentifier forIndexPath:indexPath];
                temp.messageLabel.textColor = [UIColor NMA_turquoise];
                [temp addShadow];
                cell = temp;
            }
            [cell layoutIfNeeded];
            return cell;
        }
        case NMASectionTypeNYTimesNews: {
            NMANewsStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNMANewsStoryCellIdentifier forIndexPath:indexPath];
            [cell configureCellForStory:self.NYTimesNews[indexPath.row]];
            cell.delegate = self;
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
                CGFloat imageWidth = CGRectGetWidth(((NMAFBActivityTableViewCell *)selectedCell).postImageView.frame);
                [self addModalDetailForFBActivity:fbActivity withWidth:imageWidth];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case NMASectionTypeFacebookActivity:
            return UITableViewAutomaticDimension;
        case NMASectionTypeNYTimesNews:
            return kNewsStoryHeightForRow;
        default:
            return kBillboardSongHeightForRow;
    }
}

-(UIView*)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case NMASectionTypeFacebookActivity: {
            NMASectionHeader *fbSectionHeaderCell = [tableView dequeueReusableCellWithIdentifier:kNMASectionHeaderIdentifier];
            fbSectionHeaderCell.headerLabel.text = @"Facebook Activities";
            fbSectionHeaderCell.headerImageView.image = [UIImage NMA_facebookLabel];
            fbSectionHeaderCell.upperBackgroundView.backgroundColor = [UIColor whiteColor];
            [fbSectionHeaderCell sizeToFit];
            return fbSectionHeaderCell;
        }
        case NMASectionTypeNYTimesNews: {
            NMASectionHeader *newsSectionHeaderCell = [tableView dequeueReusableCellWithIdentifier:kNMASectionHeaderIdentifier];
            newsSectionHeaderCell.headerLabel.text = @"News";
            newsSectionHeaderCell.headerImageView.image = [UIImage NMA_newsLabel];
            newsSectionHeaderCell.upperBackgroundView.backgroundColor = [UIColor clearColor];
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
            return CGFLOAT_MIN;
        default:
            return kHeightOfHeaderBanners;  
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Setter Methods

- (void)setYear:(NSString *)year {
    _year = year;
    self.day = [[NMADay alloc] initWithYear:self.year];
    [self.day populateFBActivities:self];
}

#pragma mark - NMADayDelegate

- (void)allFbActivityUpdate {
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
            return nil;
    }
}

#pragma mark - Private Utility

- (void)addModalDetailForFBActivity:(NMAFBActivity *)fbActivity withWidth:(CGFloat)pictureWidth {
    self.modalDetailViewController = [[NMAModalDetailTableViewController alloc] initWithActivity:fbActivity withWidth:pictureWidth];
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];

    [rootViewController.view addSubview:self.modalDetailViewController.view];
    self.modalDetailViewController.view.frame = rootViewController.view.bounds;
    [rootViewController addChildViewController:self.modalDetailViewController];
}

@end
