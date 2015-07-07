//
//  NMANewsStoryTableViewCell.h
//  NostalgiaMusic
//
//  Created by Sara Lieto on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMANewsStoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *bylineLabel;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
