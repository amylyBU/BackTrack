//
//  NMASettingsSwitchCell.m
//  NostalgiaMusic
//
//  Created by Sara Lieto on 7/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMASettingsSwitchCell.h"
#import "UIColor+NMAColors.h"
#import "UIFont+NMAFonts.h"

@implementation NMASettingsSwitchCell

- (void)awakeFromNib {
    self.settingsSwitch.onTintColor = [UIColor NMA_turquoise];
    self.settingsCategoryLabel.textColor = [UIColor NMA_black];
    self.settingsCategoryLabel.font = [UIFont NMA_proximaNovaRegularWithSize:16.0f];
}

- (IBAction)switchClicked:(UISwitch *)sender {
    [self.delegate didPressSwitch:sender];
}

@end
