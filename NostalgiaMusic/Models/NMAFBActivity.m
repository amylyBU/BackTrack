//
//  NMAFBPost.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAFBActivity.h"
#import "NMARequestManager.h"
#import "NMADay.h"

@interface NMAFBActivity()
@property (nonatomic, copy, readwrite) NSString *message;
@property (nonatomic, copy, readwrite) NSString *timeString;
@property (nonatomic, copy, readwrite) NSString *imageObjectId;
@property (nonatomic, readwrite) int likeCount;
@property (nonatomic, readwrite) int commentCount;
@property (strong, nonatomic) id <NMADayDelegate> dayDelegate;
@end

@implementation NMAFBActivity

#pragma mark - Initializer
- (instancetype) initWithPost:(id)post dayDelegate:(id)delegate{
    self = [super init];
    
    if(self && post) {
        //we are only interested in status and photo updates for now
        NSString *type = post[@"type"];
        if([type isEqual:@"status"] || [type isEqual:@"photo"]) {
            NSString *message = post[@"message"];
            NSString *pictureId = post[@"object_id"]; //if not a photo, this is nil
            NSString *createdTime = post[@"created_time"];
        
            _message = message;
            [self formatTimeString:createdTime];
            _imageObjectId = pictureId;
            _imagePath = nil;
            _dayDelegate = delegate;
            
            //We need to make a separate request to get a high res image for the FBActivity
            [[NMARequestManager sharedManager] requestFBActivityImage:pictureId
                                                              success:^(NSString *imagePath) {
                                                                  _imagePath = imagePath;
                                                                  //Then we need to reload with the image
                                                                  [_dayDelegate updatedFBActivity];
                                                              }
                                                              failure:nil];
            
            //We also need to make special paging requests for likes and comments
            _likeCount = [self countLikes:post];
        }
    }
    
    return self;
}

#pragma mark - Utility
- (void)formatTimeString:(NSString *)createdTime {
    //create a date from the createdTime string we are given
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZ";
    
    //convert it into a date we can spit back out
    NSDate *date = [dateFormatter dateFromString:createdTime];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    dateFormatter.dateFormat = @"h:mm a";
    
    _timeString = [dateFormatter stringFromDate:date];
}

- (int)countLikes:(id)post {
    int likeCount = 0;
    id likesObject = post[@"likes"];
    
    if(likesObject) {
        NSArray *likes = likesObject[@"data"];
        for(id like in likes) {
            NSString *likerName = like[@"name"];
            NSLog(@"%@ likes this post", likerName);
            likeCount++;
        }
        //TODO:page through the remaining lieks
    }
    return likeCount;
}

- (void)getTotalCountWithStartingCount:(NSInteger)startingCount nextPage:(NSString *)nextPage {
    
}

@end
