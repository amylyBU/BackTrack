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
@property (nonatomic, readwrite) int likeCount;
@property (nonatomic, readwrite) int commentCount;
@property (nonatomic, copy, readwrite) NSString *message;
@property (nonatomic, copy, readwrite) NSString *timeString;
@property (nonatomic, copy, readwrite) NSString *imageObjectId;
@end

@implementation NMAFBActivity

#pragma mark - Initializer
- (instancetype) initWithPost:(id)post {
    self = [super init];
    
    if(self) {
        //we are only interested in status and photo updates for now
        if (post) {
            _message = post[@"message"];
            _imageObjectId = post[@"object_id"]; //if not a photo, this is nil
            [self formatTimeString:post[@"created_time"]];
            _imagePath = nil;
            _likeCount = 0;
            _commentCount = 0;
        }
    }
    
    return self;
}

#pragma mark - Info fetching
- (void)populateActivityImagePath:(id<NMADayDelegate>)dayDelegate {
    //We need to make a separate request to get a high res image for the FBActivity
    [[NMARequestManager sharedManager] requestFBActivityImage:self.imageObjectId
                                                      success:^(NSString *imagePath) {
                                                          self.imagePath = imagePath;
                                                          //Then we need to reload with the image
                                                          [dayDelegate updatedFBActivity];
                                                      }
                                                      failure:nil];
}

- (void)populateActivityLikes:(id)likesContainer
                  dayDelegate:(id<NMADayDelegate>)dayDelegate {
    [self populateResponsesWithStart:&_likeCount responseContainer:likesContainer dayDelegate:dayDelegate];
}

- (void)populateActivityComments:(id)commentsContainer
                     dayDelegate:(id<NMADayDelegate>)dayDelegate {
    [self populateResponsesWithStart:&_commentCount responseContainer:commentsContainer dayDelegate:dayDelegate];
}

#pragma mark - Utility
- (void)formatTimeString:(NSString *)createdTime {
    //create a date from the createdTime string we are given
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZ";
    
    //convert it into a date we can spit back out
    NSDate *date = [dateFormatter dateFromString:createdTime];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = @"h:mm a";
    
    self.timeString = [dateFormatter stringFromDate:date];
}

///@discussion responses are likes or comments
- (void)populateResponsesWithStart:(int *)count
                 responseContainer:(id)responseContainer
                       dayDelegate:(id<NMADayDelegate>)dayDelegate {
    NSArray *responses = responseContainer[@"data"];
    id paging = responseContainer[@"paging"];
    NSString *nextLink = paging[@"next"];
    
    for(id response in responses) {
        (*count)++;
    }
    
    //paginate for more like if we must
    if(nextLink) {
        [[NMARequestManager sharedManager] requestFBActivityResponses:nextLink
                                                          dayDelegate:dayDelegate
                                                              success:^(id nextResponseContainer) {
                                                                  [self populateResponsesWithStart:count
                                                                                  responseContainer:nextResponseContainer
                                                                                       dayDelegate:dayDelegate];
                                                              }
                                                              failure:nil];
    } else {
        NSLog(@"%i total people (something) this post", *count);
        [dayDelegate updatedFBActivity];
    }
}

@end
