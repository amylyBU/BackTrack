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
#import "NMAFBLike.h"
#import "NMAFBComment.h"

typedef NS_ENUM(NSInteger, NMAResponseType) {
    NMAResponseTypeLike,
    NMAResponseTypeComment
};

@interface NMAFBActivity()
@property (strong, nonatomic, readwrite) NSArray *likes;
@property (strong, nonatomic, readwrite) NSArray *comments;
@property (nonatomic, copy, readwrite) NSString *message;
@property (nonatomic, copy, readwrite) NSString *timeString;
@property (nonatomic, copy, readwrite) NSString *imageObjectId;
@end

@implementation NMAFBActivity

#pragma mark - Initializer
- (instancetype) initWithPost:(NSDictionary *)post {
    self = [super init];
    
    if (self) {
        if (post) {
            _message = post[@"message"];
            _imageObjectId = post[@"object_id"]; //if not a photo, this is nil
            [self formatTimeString:post[@"created_time"]];
            _imagePath = nil;
            _likes = nil;
            _comments = nil;
        }
    }
    
    return self;
}

#pragma mark - Info fetching
- (void)populateActivityImagePath:(id<NMADayDelegate>)dayDelegate {
    if (!self.imagePath) {
        [[NMARequestManager sharedManager] requestFBActivityImage:self.imageObjectId
                                                          success:^(NSString *imagePath) {
                                                              self.imagePath = imagePath;
                                                              [dayDelegate allFbActivityUpdate];
                                                          }
                                                          failure:nil];
    }
}

- (void)populateActivityLikes:(NSDictionary *)likesContainer
                  dayDelegate:(id<NMADayDelegate>)dayDelegate {
    if (!self.likes) {
        [self populateResponsesWithStart:nil
                       responseContainer:likesContainer
                            responseType:NMAResponseTypeLike
                             dayDelegate:dayDelegate];
    }
}

- (void)populateActivityComments:(NSDictionary *)commentsContainer
                     dayDelegate:(id<NMADayDelegate>)dayDelegate {
    if (!self.comments) {
        [self populateResponsesWithStart:nil
                       responseContainer:commentsContainer
                            responseType:NMAResponseTypeComment
                             dayDelegate:dayDelegate];
    }
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
- (void)populateResponsesWithStart:(NSMutableArray *)mutableResponseArray
                 responseContainer:(NSDictionary *)responseContainer
                      responseType:(NMAResponseType)responseType
                       dayDelegate:(id<NMADayDelegate>)dayDelegate {
    if (!mutableResponseArray) {
        mutableResponseArray = [NSMutableArray new];
    }
    
    NSArray *responses = responseContainer[@"data"];
    NSDictionary *paging = responseContainer[@"paging"];
    NSString *nextLink = paging[@"next"];
    
    for (NSDictionary *response in responses) {
        switch (responseType) {
            case NMAResponseTypeLike: {
                NSString *likerName = response[@"name"];
                NMAFBLike *FBLike = [[NMAFBLike alloc] initWithName:likerName];
                [mutableResponseArray addObject:FBLike];
                break;
            }
            case NMAResponseTypeComment: {
                NSString *commenterName = (response[@"from"])[@"name"];
                NSString *message = response[@"message"];
                NSInteger likeCount = [response[@"like_count"] integerValue];
                //sticker comments have an empty message, we ignore them
                if (![message isEqualToString:@""]) {
                    NMAFBComment *FBComment = [[NMAFBComment alloc] initWithName:commenterName
                                                                         message:message
                                                                       likeCount:likeCount];
                    [mutableResponseArray addObject:FBComment];
                }
                break;
            }
            default:
                break;
        }
    }
    
    //paginate for more likes if we have nextLink exists
    if (nextLink) {
        [[NMARequestManager sharedManager] requestFBActivityResponses:nextLink
                                                          dayDelegate:dayDelegate
                                                              success:^(NSDictionary *nextResponseContainer) {
                                                                  [self populateResponsesWithStart:mutableResponseArray
                                                                                  responseContainer:nextResponseContainer
                                                                                      responseType:responseType
                                                                                       dayDelegate:dayDelegate];
                                                                  [dayDelegate allFbActivityUpdate];
                                                              }
                                                              failure:nil];
    } else {
        switch (responseType) {
            case NMAResponseTypeLike: {
                self.likes = [mutableResponseArray copy];
            }
                break;
            case NMAResponseTypeComment: {
                self.comments = [mutableResponseArray copy];
            }
            default:
                break;
        }
        //If we reach this case, we've captured all response so update delegate
        [dayDelegate allFbActivityUpdate];
    }
}

@end
