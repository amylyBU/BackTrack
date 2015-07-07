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
#import <SVPullToRefresh.h>
#import "NMARequestManager.h"
#import "NMAAppSettings.h"

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

@interface NMAContentTableViewController ()

@property (strong, nonatomic) NSMutableArray *billboardSongs;
@property (strong, nonatomic) NSMutableArray *facebookActivities;
@property (strong, nonatomic) NSMutableArray *NYTimesNews;

@end

@implementation NMAContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMATodaysSongTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kNMATodaysSongCellIdentifier];

    self.billboardSongs = [[NSMutableArray alloc] init];
    self.facebookActivities = [[NSMutableArray alloc] init];
    self.NYTimesNews = [[NSMutableArray alloc] init];

    if (self.year) {
        [[NMARequestManager sharedManager] getSongFromYear:self.year
                                                   success:^(NMASong *song) {
                                                       [self.billboardSongs addObject:song];

                                                       [self.tableView reloadData];
                                                   }
                                                   failure:^(NSError *error) {
                                                       NSLog(@"something went horribly wrong"); //TODO: handle error
                                                   }];
    }

    __weak NMAContentTableViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }];
}

<<<<<<< HEAD
- (void)makeiTunesWebCall:(NMASong *)song {
    [[NMARequestManager sharedManager] getiTunesMusicForSong:song
                                                     success:^(NMASong *songWithPreview) {
                                                         [self.billboardSongs addObject:songWithPreview];
                                                         [self.tableView reloadData];
                                                         NSLog(@"success");
                                                     } failure:^(NSError *error) {
                                                         NSLog(@"failed"); //TODO: handle error
                                                     }];
}

- (void)setUpMusicPlayerWithUrl:(NSURL *)previewUrl {
    NSError *error = [[NSError alloc] init];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:previewUrl error:&error];
    player.numberOfLoops = 1; //TODO: configure autoplay settings

    //TODO: initialize player.delegate when the home view controller is initialized
    [player prepareToPlay];

    if (player) {
        if ([[NMAAppSettings sharedSettings] userDidAutoplay]) {
            [player play];
        }
    } else {
        NSLog(@"%@",[error description]); //TODO: handle error
    }
}

=======
>>>>>>> ebf1342... refactored web calls and cell configuration. return statements for switch cases. Can now view songs and album images from iTunes.
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
<<<<<<< HEAD

    NSInteger numRows = 0;
=======
>>>>>>> ebf1342... refactored web calls and cell configuration. return statements for switch cases. Can now view songs and album images from iTunes.
    switch (section) {
        case NMASectionTypeBillboardSong:
            return self.billboardSongs.count;
        case NMASectionTypeFacebookActivity:
            return self.facebookActivities.count;
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
        case NMASectionTypeFacebookActivity:

        case NMASectionTypeNYTimesNews:

        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kBillboardSongHeightForRow;
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

@end
