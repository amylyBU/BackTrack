//
//  NMADay.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMADay.h"
#import "NMASong.h"
#import "NMAFBActivity.h"
#import "FBSDKGraphRequest.h"
#import "NMARequestManager.h"

@interface NMADay()
@property (strong, nonatomic, readwrite) NSString *year;
@property (strong, nonatomic, readwrite) NMASong *song;
@property (strong, nonatomic, readwrite) NSArray *FBActivities;
//TODO: add news property
@end

@implementation NMADay

#pragma mark - Initializer

- (instancetype) initWithYear:(NSString *)year dayDelgate:(id<NMADayDelegate>)dayDelegate {
    self = [super init];
    
    if(self) {
        _year = year; //TODO: check for valid years
        _delegate = dayDelegate;
        //TODO: initialize song
        [self collectFBActivities];
        //TODO: collect stories
    }
    
    return self;
}

#pragma mark - Facebook Post Utility

- (void)collectFBActivities {
    [[NMARequestManager sharedManager] requestFBActivitiesFromDate:self.year
                                                       dayDelegate:self.delegate
                                                           success:^(NSArray *FBActivities) {
                                                               self.FBActivities = FBActivities;
                                                               [self.delegate updatedFBActivity];
                                                           }
                                                           failure:nil];
}

@end
