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
@property (strong, nonatomic, readwrite) NMASong *song;
@property (strong, nonatomic, readwrite) NSArray *fbActivities;
//TODO: add news property
@end

@implementation NMADay

#pragma mark - Initializer

- (instancetype)initWithYear:(NSString *)year {
    self = [super init];
    
    if (self) {
        _year = year; //TODO: check for valid years
    }
    
    return self;
}

#pragma mark - Facebook Post Utility

- (void)populateFBActivities:(id<NMADayDelegate>)dayDelegate {
    [[NMARequestManager sharedManager] requestFBActivitiesFromDate:self.year
                                                       dayDelegate:dayDelegate
                                                           success:^(NSArray *FBActivities) {
                                                               self.fbActivities = FBActivities;
                                                               [dayDelegate allFbActivityUpdate];
                                                           }
                                                           failure:nil];
}

@end
