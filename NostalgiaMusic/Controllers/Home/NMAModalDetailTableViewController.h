//
//  NMAModalDetailTableViewController.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/20/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMAFBActivityTableViewCell.h"

@interface NMAModalDetailTableViewController : UITableViewController <NMAFBActivityCellDelegate>

@property (strong, nonatomic) NMAFBActivity *fbActivity;

- (instancetype)initWithActivity:(NMAFBActivity *)fbActivity;

@end
