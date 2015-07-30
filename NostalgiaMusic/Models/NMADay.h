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
@class NMANewsStory;

@protocol NMADayDelegate

- (void)dayUpdate;

@end

@interface NMADay : NSObject

@property (strong, nonatomic, readonly) NSString *year;
@property (strong, nonatomic) NMASong *song;
@property (strong, nonatomic, readonly) NSArray *fbActivities;
@property (strong, nonatomic, readonly) NMANewsStory *nyTimesNews;

- (instancetype)initWithYear:(NSString *)year;
- (void)populateSong:(id<NMADayDelegate>)dayDelegate;
- (void)populateFBActivities:(id<NMADayDelegate>)dayDelegate;
- (void)populateNews:(id<NMADayDelegate>)dayDelegate;

@end