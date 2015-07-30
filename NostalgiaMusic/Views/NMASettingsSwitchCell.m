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
    [super awakeFromNib];
    self.settingsSwitch.onTintColor = [UIColor nma_turquoise];
    self.settingsCategoryLabel.textColor = [UIColor nma_black];
    self.settingsCategoryLabel.font = [UIFont nma_proximaNovaRegularWithSize:16.0f];
}

- (IBAction)switchClicked:(UISwitch *)sender {
    [self.delegate didPressSwitch:sender];
}

@end
