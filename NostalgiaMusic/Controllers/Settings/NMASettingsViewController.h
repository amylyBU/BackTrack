//
//  NMASettingsViewController.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMASettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UISwitch *facebookSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoplayMusicSwitch;
@property (weak, nonatomic) IBOutlet UILabel *facebookLabel;
@property (weak, nonatomic) IBOutlet UILabel *autoplayMusicLabel;
@property (weak, nonatomic) IBOutlet UITableView *staticTableView;

@end
