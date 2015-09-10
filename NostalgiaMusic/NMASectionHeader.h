//
//  NMAFBSectionHeader.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/13/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMASectionHeader : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIView *upperBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end
