//
//  NMAFBPost.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAFBActivity.h"

@interface NMAFBActivity()
@property (strong, nonatomic, readwrite) NSString *message;
@property (strong, nonatomic, readwrite) NSString *timeString;
@property (strong, nonatomic, readwrite) NSString *pictureObjectId;
@end

@implementation NMAFBActivity

#pragma mark - Initializer
- (instancetype) initWithMessage:(NSString *)message
                 pictureObjectId:(NSString *)pictureObjectId
                     createdTime:(NSString *)createdTime {
    self = [super init];
    
    if(self) {
        self.message = message;
        [self formatTimeString:createdTime];
        self.pictureObjectId = pictureObjectId;
        self.picturePath = nil;
    }
    
    return self;
}

#pragma mark - Utility
- (void)formatTimeString:(NSString *)createdTime {
    //create a date from the createdTime string we are given
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    
    //convert it into a date we can spit back out
    NSDate *date = [dateFormatter dateFromString:createdTime];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"h:mm a"];
    
    self.timeString = [dateFormatter stringFromDate:date];
}

@end
