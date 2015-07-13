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
    [self populateLikesWithStart:&_likeCount likesContainer:likesContainer dayDelegate:dayDelegate];
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

- (void)populateLikesWithStart:(int *)count
                likesContainer:(id)likesContainer
                   dayDelegate:(id<NMADayDelegate>)dayDelegate {
    NSArray *likes = likesContainer[@"data"];
    id paging = likesContainer[@"paging"];
    NSString *nextLink = paging[@"next"];
    
    for(id like in likes) {
        NSString *likerName = like[@"name"];
        NSLog(@"%@ likes this post", likerName);
        (*count)++;
    }
    
    //paginate for more like if we must
    if(nextLink) {
        [[NMARequestManager sharedManager] requestFBActivityLikes:nextLink
                                                      dayDelegate:dayDelegate
                                                          success:^(id nextLikeContainer) {
                                                              [self populateLikesWithStart:count
                                                                            likesContainer:nextLikeContainer
                                                                               dayDelegate:dayDelegate];
                                                          }
                                                          failure:nil];
    } else {
        NSLog(@"%i total people like this post", *count);
        [dayDelegate updatedFBActivity];
    }
}

@end
