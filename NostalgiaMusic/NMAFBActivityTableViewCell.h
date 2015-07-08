//
//  NMAFBActivityTableViewCell.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/7/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMAFBActivity.h"
@interface NMAFBActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *postMessage;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postImageHeightConstraint;

- (void)configureCellForFBActivity:(NMAFBActivity *)FBPost;
- (void)configureEmptyCell;

@end
