//
//  NMASettingsSwitchCell.h
//  NostalgiaMusic
//
//  Created by Sara Lieto on 7/9/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NMASettingsSwitchCellDelegate<NSObject>

- (void)didPressSwitch:(id)sender;

@end

@interface NMASettingsSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *settingsCategoryLabel;
@property (weak, nonatomic) IBOutlet UISwitch *settingsSwitch;
@property (weak, nonatomic) id <NMASettingsSwitchCellDelegate> delegate;

@end
