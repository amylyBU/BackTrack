//
//  NMAContentTableViewController.h
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/25/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMADay.h"
#import "NMAFBActivityTableViewCell.h"

@interface NMAContentTableViewController : UITableViewController <NMADayDelegate, NMAFBActivityCellDelegate>

@property (copy, nonatomic) NSString *year;
@property (strong, nonatomic, readonly) NMADay *day;


- (void)setUpPlayerForTableCell;

@end
