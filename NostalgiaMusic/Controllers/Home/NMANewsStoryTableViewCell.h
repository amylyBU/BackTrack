//
//  NMANewsStoryTableViewCell.h
//  NostalgiaMusic
//
//  Created by Sara Lieto on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMANewsStory.h"

@interface NMANewsStoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *bylineLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueReadingButton;
@property (strong, nonatomic) NMANewsStory *story;
@property (strong, nonatomic) UIViewController<NSObject> *delegate;

- (void)configureCellForStory:(NMANewsStory *)story;

@end
