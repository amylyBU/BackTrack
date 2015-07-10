//
//  NMADay.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMADay.h"

@interface NMADay()
@property (strong, nonatomic, readwrite) NSString *year;
@property (strong, nonatomic, readwrite) NMASong *song;
@property (strong, nonatomic, readwrite) NSArray *FBActivities;
//TODO: add news property
@end

@implementation NMADay

#pragma mark - Initializer

- (instancetype) initWithYear:(NSString *)year {
    self = [super init];
    
    if(self) {
        self.year = year; //TODO: check for valid years
        //TODO: initialize song
        [self collectFBActivities];
        //TODO: collect stories
    }
    
    return self;
}

#pragma mark - Facebook Post Utility

- (void)collectFBActivities {
    [[NMARequestManager sharedManager] requestFBActivitiesFromDate:_year
                                                       dayDelegate:_delegate
                                                           success:^(NSArray *FBActivities) {
                                                               _FBActivities = FBActivities;
                                                               [self.delegate updatedFBActivity];
                                                           }
                                                           failure:nil];
}

@end
