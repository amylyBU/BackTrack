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
#import <AVFoundation/AVFoundation.h>
#import "NMAAppSettings.h"

NS_ENUM(NSInteger, NMASectionType) {
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
        [[NMARequestManager sharedManager] getSongFromYear:self.year success:^(NMASong *song) {
            [self makeiTunesWebCall:song];
        } failure:^(NSError *error) {
            NSLog(@"something went horribly wrong"); //TODO: handle error
        }];
    }

    __weak NMAContentTableViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }];
}

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

    NSInteger numRows = 0;
    switch (section) {
        case NMASectionTypeBillboardSong:
            numRows = self.billboardSongs.count;
            break;
        case NMASectionTypeFacebookActivity:
            numRows = self.facebookActivities.count;
            break;
        case NMASectionTypeNYTimesNews:
            numRows = self.NYTimesNews.count;
            break;
    }
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NMATodaysSongTableViewCell *songCell;
    //TODO: declare other table view cell classes

    switch (indexPath.section) {

        case NMASectionTypeBillboardSong:
           songCell = [tableView dequeueReusableCellWithIdentifier:kNMATodaysSongCellIdentifier forIndexPath:indexPath];
            songCell.songTitleLabel.text = ((NMASong *)self.billboardSongs[0]).title;
            songCell.artistLabel.text = ((NMASong *)self.billboardSongs[0]).artistAsAppearsOnLabel;
            songCell.albumImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:((NMASong *)self.billboardSongs[0]).albumImageUrlsArray[0]]]];
            songCell.albumImage.layer.cornerRadius = songCell.albumImage.frame.size.height /2;
            songCell.albumImage.layer.masksToBounds = YES;
            break;

        case NMASectionTypeFacebookActivity:
            //TODO: set up cell for facebook activity from model
            break;

        case NMASectionTypeNYTimesNews:
            //TODO: set up cell for news from model
            break;

    }
    return songCell; // TODO: move return statements
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kBillboardSongHeightForRow;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {

    NSString *sectionTitle;
    switch (section) {
        case NMASectionTypeBillboardSong:
            sectionTitle = @"Top 100 Billboard Song"; //TODO: Remove this title, it is not in the design.
            break;
        case NMASectionTypeFacebookActivity:
            sectionTitle = @"Facebook Activities";
            break;
        case NMASectionTypeNYTimesNews:
            sectionTitle = @"News";
            break;
    }
    return sectionTitle;
}

@end
