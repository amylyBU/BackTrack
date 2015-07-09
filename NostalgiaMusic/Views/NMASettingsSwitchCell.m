//
//  NMASettingsSwitchCell.m
//  NostalgiaMusic
//
//  Created by Sara Lieto on 7/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMASettingsSwitchCell.h"

@implementation NMASettingsSwitchCell

- (IBAction)switchClicked:(id)sender {
    [self.delegate didPressSwitch:sender];
}

@end
