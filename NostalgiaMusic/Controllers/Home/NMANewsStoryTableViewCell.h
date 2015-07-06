//
//  NMANewsStoryTableViewCell.h
//  NostalgiaMusic
//
//  Created by Sara Lieto on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMANewsStoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UILabel *byline;
@property (weak, nonatomic) IBOutlet UITextView *summary;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
