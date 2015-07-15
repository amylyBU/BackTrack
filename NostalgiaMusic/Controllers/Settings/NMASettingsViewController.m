//
//  NMASettingsViewController.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMASettingsViewController.h"
#import "NMAAppSettings.h"
#import "NMASettingsSwitchCell.h"
#import "NMAFeedbackTableViewCell.h"
#import "UIColor+NMAColors.h"
#import "UIFont+NMAFonts.h"

static NSString * const kNMASettingsSwitchCellIdentifier = @"SettingsSwitchCell";
static NSString * const kNMAFeedbackTableViewCellIdentifier = @"FeedbackTableViewCell";
static NSInteger const kNumberOfSwitchTableCells = 2;
static NSInteger const kNumberOfFeedbackTableCells = 1;
static NSInteger const kNumberOfSections = 2;

NS_ENUM(NSInteger, NMASettingsSectionType) {
    NMASectionTypeSwitchCell,
    NMASectionTypeFeedbackCell,
};

NS_ENUM(NSInteger, NMASwitchCellRowTagIdentifer) {
    NMAFacebookConnectRowTag,
    NMAAutoplayRowTag
};

@interface NMASettingsViewController () <UITableViewDataSource, UITableViewDelegate, NMASettingsSwitchCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *staticTableView;

@end


@implementation NMASettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.staticTableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMASettingsSwitchCell class]) bundle:nil]
               forCellReuseIdentifier:kNMASettingsSwitchCellIdentifier];
    [self.staticTableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMAFeedbackTableViewCell class]) bundle:nil]
               forCellReuseIdentifier:kNMAFeedbackTableViewCellIdentifier];
    self.staticTableView.delegate = self;
    self.staticTableView.dataSource = self;
    [self configureUI];
}

- (void)configureUI {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Settings";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor NMA_turquoise];
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                     NSFontAttributeName:[UIFont NMA_proximaNovaRegularWithSize:20.0f] };
    self.staticTableView.separatorColor = [UIColor NMA_turquoise];
    self.view.backgroundColor = [UIColor NMA_backgroundGray];
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return section == NMASectionTypeSwitchCell ? kNumberOfSwitchTableCells : kNumberOfFeedbackTableCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case NMASectionTypeSwitchCell: {
            if (indexPath.row == NMAFacebookConnectRowTag) {
                NMASettingsSwitchCell *facebookCell = [tableView dequeueReusableCellWithIdentifier:@"SettingsSwitchCell" forIndexPath:indexPath];
                facebookCell.settingsCategoryLabel.text = @"Connect to Facebook";
                facebookCell.settingsSwitch.on = [[NMAAppSettings sharedSettings] userIsLoggedIn];
                facebookCell.delegate = self;
                facebookCell.settingsSwitch.tag = NMAFacebookConnectRowTag;
                return facebookCell;
            } else {
                NMASettingsSwitchCell *autoplayCell = [tableView dequeueReusableCellWithIdentifier:kNMASettingsSwitchCellIdentifier forIndexPath:indexPath];
                autoplayCell.settingsCategoryLabel.text = @"Autoplay";
                autoplayCell.settingsSwitch.on = [[NMAAppSettings sharedSettings] userDidAutoplay];
                autoplayCell.delegate = self;
                autoplayCell.settingsSwitch.tag = NMAAutoplayRowTag;
                return autoplayCell;
            }
        }
        case NMASectionTypeFeedbackCell: {
            NMAFeedbackTableViewCell *feedbackCell = [tableView dequeueReusableCellWithIdentifier:kNMAFeedbackTableViewCellIdentifier forIndexPath:indexPath];
            feedbackCell.feedbackLabel.text = @"Feedback";
            return feedbackCell;
        }
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == NMASectionTypeFeedbackCell) {
        [self sendEmailFeedback];
    }
}

- (void)sendEmailFeedback {
    NSString *recipientsAndSubject = @"mailto:sara@intrepid.io?subject=Feedback for Nostalgia";
    NSString *body = @"&body=";
    NSString *feedbackEmail = [NSString stringWithFormat:@"%@%@", recipientsAndSubject, body];
    feedbackEmail = [feedbackEmail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:feedbackEmail]];
}

#pragma mark - Switch statement delegate method

- (void)didPressSwitch:(UISwitch *)sender {
    if (sender.tag == NMAFacebookConnectRowTag) {
        if (sender.on) {
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                if (error) {
                    // TODO: handle error
                } else if (result.isCancelled) {
                    // TODO: handle cancellations
                } else {
                    // TODO: check if specific permissions are missing
                    if ([result.grantedPermissions containsObject:@"email"]) {
                        [[NMAAppSettings sharedSettings] setAccessToken:result.token];
                    }
                } //TODO: handle accesstoken expirations, etc
            }];
        } else {
            [[NMAAppSettings sharedSettings] setAccessToken:nil];
        }
    } else {
        sender.on ? [[NMAAppSettings sharedSettings] setAutoplaySettingToOn] : [[NMAAppSettings sharedSettings] setAutoplaySettingToOff];
    }
}


@end
