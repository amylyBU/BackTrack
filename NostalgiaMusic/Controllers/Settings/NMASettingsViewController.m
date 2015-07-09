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

static NSString * const kNMASettingsSwitchCellIdentifier = @"SettingsSwitchCell";
static NSString * const kNMAFeedbackTableViewCellIdentifier= @"FeedbackTableViewCell";

@interface NMASettingsViewController () <UITableViewDataSource, UITableViewDelegate, NMASettingsSwitchCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *staticTableView;
@end

@implementation NMASettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.staticTableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMASettingsSwitchCell class]) bundle:nil]
         forCellReuseIdentifier:kNMASettingsSwitchCellIdentifier];
    [self.staticTableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMAFeedbackTableViewCell class]) bundle:nil]
               forCellReuseIdentifier:kNMAFeedbackTableViewCellIdentifier];
    self.staticTableView.delegate = self;
    self.staticTableView.dataSource = self;
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NMASettingsSwitchCell *facebookCell = [tableView dequeueReusableCellWithIdentifier:@"SettingsSwitchCell" forIndexPath:indexPath];
            facebookCell.settingsCategoryLabel.text = @"Connect to Facebook";
            facebookCell.settingsSwitch.on = [[NMAAppSettings sharedSettings] userIsLoggedIn];
            facebookCell.delegate = self;
            facebookCell.settingsSwitch.tag = 0;
            return facebookCell;
        } else {
            NMASettingsSwitchCell *autoplayCell =  [tableView dequeueReusableCellWithIdentifier:kNMASettingsSwitchCellIdentifier forIndexPath:indexPath];
            autoplayCell.settingsCategoryLabel.text = @"Autoplay";
            autoplayCell.settingsSwitch.on = [[NMAAppSettings sharedSettings] userDidAutoplay];
            autoplayCell.delegate = self;
            autoplayCell.settingsSwitch.tag = 1;
            return autoplayCell;
        }
    } else {
        NMAFeedbackTableViewCell *feedbackCell =  [tableView dequeueReusableCellWithIdentifier:kNMAFeedbackTableViewCellIdentifier forIndexPath:indexPath];
        feedbackCell.feedbackLabel.text = @"Feedback";
        return feedbackCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) {
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
    if (sender.tag == 0) {
        NSLog(@"Facebook Settings Toggled. Settings are not saved.");
    } else {
        if (sender.on) {
            [[NMAAppSettings sharedSettings] setAutoplaySettingToOn];
            
        } else {
            [[NMAAppSettings sharedSettings] setAutoplaySettingToOff];
            
        }
    }
}

@end
