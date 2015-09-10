//
//  NMADay.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMADay.h"
#import "NMASong.h"
#import "FBSDKGraphRequest.h"
#import "NMARequestManager.h"

@interface NMADay()

@property (strong, nonatomic, readwrite) NSString *year;
@property (strong, nonatomic, readwrite) NSArray *fbActivities;
@property (strong, nonatomic, readwrite) NMANewsStory *nyTimesNews;

@end

@implementation NMADay

static const NSInteger kNumberOfFBActivities = 3;

#pragma mark - Initializer

- (instancetype)initWithYear:(NSString *)year {
    self = [super init];
    if (self) {
        _year = year; //TODO: check for valid years
    }
    return self;
}

#pragma mark - Population Methods

- (void)populateSong:(id<NMADayDelegate>)dayDelegate {
    [[NMARequestManager sharedManager] getSongFromYear:self.year success:^(NMASong *song) {
        self.song = song;
        [dayDelegate dayUpdate];
    } failure:^(NSError *error) {}];
}

- (void)populateFBActivities:(id<NMADayDelegate>)dayDelegate {
    [[NMARequestManager sharedManager] requestFBActivitiesFromYear:self.year
                                                            amount:kNumberOfFBActivities
                                                       dayDelegate:dayDelegate
                                                           success:^(NSArray *fbActivities) {
                                                               //We reverse the array because we get the activities from later in the day
                                                               //to earlier, but we want earlier day posts to show up first
                                                               NSArray *reversedActivities = [[fbActivities reverseObjectEnumerator] allObjects];
                                                               self.fbActivities = reversedActivities;
                                                           }
                                                           failure:nil];
}

- (void)populateNews:(id<NMADayDelegate>)dayDelegate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMdd"];
    NSString *currentDayMonth = [dateFormatter stringFromDate:[NSDate date]];
    NMARequestManager *manager = [[NMARequestManager alloc] init];
    [manager getNewYorkTimesStory:currentDayMonth onYear:self.year
                          success:^(NMANewsStory *story) {
                              self.nyTimesNews = story;
                              [dayDelegate dayUpdate];
                          }
                          failure:^(NSError *error) {
                          }];
}

@end
