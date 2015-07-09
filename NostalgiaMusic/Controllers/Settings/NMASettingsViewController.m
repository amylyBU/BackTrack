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

@interface NMASettingsViewController ()
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
         forCellReuseIdentifier:@"Cell"];
    
    [self.settings addObject:@"test"];
}

- (IBAction)launchMailAppOnDevice:(UIButton *)sender {
    NSString *recipientsAndSubject = @"mailto:sara@intrepid.io?subject=Feedback for Nostalgia";
    NSString *body = @"&body=";
    NSString *feedbackEmail = [NSString stringWithFormat:@"%@%@", recipientsAndSubject, body];
    feedbackEmail = [feedbackEmail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:feedbackEmail]];
}

#pragma mark - UITableViewDelegate Methods

- (IBAction)switchAutoplay:(id)sender {
    if (self.autoplayMusicSwitch.on) {
          [[NMAAppSettings sharedSettings] setAutoplaySettingToOn];
      
    } else {
          [[NMAAppSettings sharedSettings] setAutoplaySettingToOff];

    }
}
@end
