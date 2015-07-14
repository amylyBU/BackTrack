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
    FBLike,
    FBComment
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
- (instancetype) initWithPost:(id)post {
    self = [super init];
    
    if(self) {
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
                                                              [dayDelegate updatedFBActivity];
                                                          }
                                                          failure:nil];
    }
}

- (void)populateActivityLikes:(id)likesContainer
                  dayDelegate:(id<NMADayDelegate>)dayDelegate {
    if(!self.likes) {
        NSMutableArray *mutableLikeArray = [NSMutableArray new];
        [self populateResponsesWithStart:mutableLikeArray
                       responseContainer:likesContainer
                            responseType:FBLike
                             dayDelegate:dayDelegate];
    }
}

- (void)populateActivityComments:(id)commentsContainer
                     dayDelegate:(id<NMADayDelegate>)dayDelegate {
    if (!self.comments) {
        NSMutableArray *mutableCommentArray = [NSMutableArray new];
        [self populateResponsesWithStart:mutableCommentArray
                       responseContainer:commentsContainer
                            responseType:FBComment
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
                 responseContainer:(id)responseContainer
                      responseType:(NMAResponseType)responseType
                       dayDelegate:(id<NMADayDelegate>)dayDelegate {
    NSArray *responses = responseContainer[@"data"];
    id paging = responseContainer[@"paging"];
    NSString *nextLink = paging[@"next"];
    
    for(id response in responses) {
        switch (responseType) {
            case FBLike: {
                NSString *likerName = response[@"name"];
                NMAFBLike *FBLike = [[NMAFBLike alloc] initWithName:likerName];
                [mutableResponseArray addObject:FBLike];
                break;
            }
            case FBComment: {
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
    if(nextLink) {
        [[NMARequestManager sharedManager] requestFBActivityResponses:nextLink
                                                          dayDelegate:dayDelegate
                                                              success:^(id nextResponseContainer) {
                                                                  [self populateResponsesWithStart:mutableResponseArray
                                                                                  responseContainer:nextResponseContainer
                                                                                      responseType:responseType
                                                                                       dayDelegate:dayDelegate];
                                                              }
                                                              failure:nil];
    } else {
        switch (responseType) {
            case FBLike: {
                self.likes = [mutableResponseArray copy];
            }
                break;
            case FBComment: {
                self.comments = [mutableResponseArray copy];
            }
            default:
                break;
        }
        //If we reach this case, we've captured all response so update delegate
        [dayDelegate updatedFBActivity];
    }
}

@end
