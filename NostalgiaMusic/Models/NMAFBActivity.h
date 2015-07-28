//
//  NMAFBPost.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol NMADayDelegate;

@interface NMAFBActivity : NSObject

@property (strong, nonatomic, readonly) NSArray *likes; //of NMAFBLikes
@property (strong, nonatomic, readonly) NSArray *comments; //of NMAFBComments
@property (copy, nonatomic) NSString *imagePath;
@property (copy, nonatomic, readonly) NSString *message;
@property (copy, nonatomic, readonly) NSString *imageId;
@property (copy, nonatomic, readonly) NSString *timeString;
@property (nonatomic) BOOL hasImage;

- (instancetype)initWithPost:(NSDictionary *)post;
- (void)populateActivityImagePath:(id<NMADayDelegate>)dayDelegate;
- (void)populateActivityLikes:(NSDictionary *)likesContainer
                  dayDelegate:(id<NMADayDelegate>)dayDelegate;
- (void)populateActivityComments:(NSDictionary *)commentsContainer
                     dayDelegate:(id<NMADayDelegate>)dayDelegate;

@end
