//
//  NMANoFBActivityTableViewCell.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/8/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMANoFBActivityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

- (void) addShadow;

@end
