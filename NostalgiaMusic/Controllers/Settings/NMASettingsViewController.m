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

@interface NMASettingsViewController () <UITableViewDataSource, UITableViewDelegate>
@property  NSMutableArray *settings;

@end

@implementation NMASettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.feedbackButton addTarget:self
                            action:@selector(launchMailAppOnDevice:)
                  forControlEvents:UIControlEventTouchUpInside];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([[NMAAppSettings sharedSettings] userDidAutoplay]) {
        [self.autoplayMusicSwitch setOn:YES];
    } else {
        [self.autoplayMusicSwitch setOn:NO];
    }
    
    if ([[NMAAppSettings sharedSettings] userIsLoggedIn]) {
        [self.facebookSwitch setOn:YES];
    } else {
        [self.facebookSwitch setOn:NO];
    }
    
    [self.staticTableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMASettingsSwitchCell class]) bundle:nil]
         forCellReuseIdentifier:@"SettingsSwitchCell"];
    [self.staticTableView registerNib:[UINib nibWithNibName:NSStringFromClass([NMAFeedbackTableViewCell class]) bundle:nil]
               forCellReuseIdentifier:@"FeedbackTableViewCell"];
    self.settings = [[NSMutableArray alloc]init];
    //[self configureSettingsDataSource];
    [self.staticTableView setDelegate:self];
    [self.staticTableView setDataSource:self];

}

- (void)configureSettingsDataSource {
    NMASettingsSwitchCell *facebookCell = [[NMASettingsSwitchCell alloc] init];
    facebookCell.settingsCategoryLabel.text = @"Connect to Facebook";
    if ([[NMAAppSettings sharedSettings] userIsLoggedIn]) {
        [facebookCell.settingsSwitch setOn:YES];
    } else {
        [facebookCell.settingsSwitch setOn:NO];
    }
    [self.settings addObject:facebookCell];
    
    NMASettingsSwitchCell *autoplayCell = [[NMASettingsSwitchCell alloc] init];
    autoplayCell.settingsCategoryLabel.text = @"Autoplay";
    if ([[NMAAppSettings sharedSettings] userDidAutoplay]) {
        [autoplayCell.settingsSwitch setOn:YES];
    } else {
        [autoplayCell.settingsSwitch  setOn:NO];
    }
    [self.settings addObject:autoplayCell];
    
    NMAFeedbackTableViewCell *feedbackCell = [[NMAFeedbackTableViewCell alloc] init];
    feedbackCell.feedbackLabel.text = @"Feedback";
    [self.settings addObject:feedbackCell];
    
    
}

- (IBAction)launchMailAppOnDevice:(UIButton *)sender {
    NSString *recipientsAndSubject = @"mailto:sara@intrepid.io?subject=Feedback for Nostalgia";
    NSString *body = @"&body=";
    NSString *feedbackEmail = [NSString stringWithFormat:@"%@%@", recipientsAndSubject, body];
    feedbackEmail = [feedbackEmail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:feedbackEmail]];
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
            if ([[NMAAppSettings sharedSettings] userIsLoggedIn]) {
                [facebookCell.settingsSwitch setOn:YES];
            } else {
                [facebookCell.settingsSwitch setOn:NO];
            }
            return facebookCell;
        } else {
            NMASettingsSwitchCell *autoplayCell =  [tableView dequeueReusableCellWithIdentifier:@"SettingsSwitchCell" forIndexPath:indexPath];
            autoplayCell.settingsCategoryLabel.text = @"Autoplay";
            if ([[NMAAppSettings sharedSettings] userDidAutoplay]) {
                [autoplayCell.settingsSwitch setOn:YES];
            } else {
                [autoplayCell.settingsSwitch  setOn:NO];
            }
            return autoplayCell;
        }
    } else {
        NMAFeedbackTableViewCell *feedbackCell =  [tableView dequeueReusableCellWithIdentifier:@"FeedbackTableViewCell" forIndexPath:indexPath];
        feedbackCell.feedbackLabel.text = @"Feedback";
        return feedbackCell;
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1) {
        NSString *recipientsAndSubject = @"mailto:sara@intrepid.io?subject=Feedback for Nostalgia";
        NSString *body = @"&body=";
        NSString *feedbackEmail = [NSString stringWithFormat:@"%@%@", recipientsAndSubject, body];
        feedbackEmail = [feedbackEmail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:feedbackEmail]];

    }
}

- (IBAction)switchAutoplay:(id)sender {
    if (self.autoplayMusicSwitch.on) {
          [[NMAAppSettings sharedSettings] setAutoplaySettingToOn];
      
    } else {
          [[NMAAppSettings sharedSettings] setAutoplaySettingToOff];

    }
}
@end
