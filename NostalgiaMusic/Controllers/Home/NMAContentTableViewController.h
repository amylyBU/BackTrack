//
//  NMAContentTableViewController.h
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/25/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMADay.h"

@interface NMAContentTableViewController : UITableViewController <NMADayDelegate>

@property (copy, nonatomic) NSString *year;
@property (strong, nonatomic, readonly) NMADay *day;

- (void)playAudioPlayer;

@end
