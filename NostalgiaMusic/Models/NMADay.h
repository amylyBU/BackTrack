//
//  NMADay.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMAFBActivity.h"

@class NMASong;

@protocol NMADayDelegate

- (void)allFbActivityUpdate;

@end

@interface NMADay : NSObject

@property (strong, nonatomic, readonly) NMASong *song;
@property (strong, nonatomic, readonly) NSString *year;
@property (strong, nonatomic, readonly) NSArray *fbActivities;

- (instancetype)initWithYear:(NSString *)year;
- (void)populateFBActivities:(id<NMADayDelegate>)dayDelegate;

@end