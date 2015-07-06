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
@property (strong, nonatomic, readwrite) NSArray *FBPosts;
@end

@implementation NMADay

#pragma mark - Initializer

- (instancetype) initWithYear:(NSString *)year {
    self = [super init];
    
    if(self) {
        self.year = year; //TODO: check for valid years
        //TODO: initialize song
        [self collectFBPosts];
    }
    
    return self;
}

#pragma mark - Facebook Post Utility

- (void) collectFBPosts {
    NSMutableArray *mutablePosts = [[NSMutableArray alloc] init];
    
    //Collect today's date information
    NSDateComponents *presentDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                              fromDate:[NSDate date]];
    
    //Create a date in the past of today's date (month & day) during our year
    NSDateComponents *targetDateComponents = [[NSDateComponents alloc] init];
    [targetDateComponents setYear:[self.year integerValue]];
    [targetDateComponents setMonth:presentDateComponents.month];
    [targetDateComponents setDay:presentDateComponents.day];
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *targetDate = [gregorianCal dateFromComponents:targetDateComponents];
    
    //Format the target date into a string we can make the reqest with
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateFormatter stringFromDate:targetDate];
    NSString *dayStart = @"T00:00:00";
    NSString *dayEnd = @"T23:59:59";
    NSString *sinceTime = [NSString stringWithFormat:@"%@%@", date, dayStart];
    NSString *untilTime = [NSString stringWithFormat:@"%@%@", date, dayEnd];
    NSDictionary *params = @{
                             @"since" : sinceTime,
                             @"until" : untilTime
                             };
    NSString *path = @"/me/posts";
    
    //Build the request to get all posts during that day
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:path
                                                                   parameters:params
                                                                   HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        //result is actually of type NSCFDictionary it seems
        NSArray *posts = [result objectForKey:@"data"];
        for(id post in posts) {
            //We look for all of these keys indiscrimintently, but certain
            //types of posts won't have these keys, so will just be nil
            //In the displaying of these keys, we check for nil
            NSString *message = [post objectForKey:@"message"];
            NSString *picture = [post objectForKey:@"picture"];
            NSString *createdTime = [post objectForKey:@"created_time"];
            NMAFBPost *FBPost = [[NMAFBPost alloc] initWithMessage:message
                                                       picturePath:picture
                                                         likeCount:0
                                                      commentCount:0
                                                       createdTime:createdTime];
            NSLog(FBPost.message);
            [mutablePosts addObject:FBPost];
        }
        
        self.FBPosts = [mutablePosts copy];
    }];
}

@end
