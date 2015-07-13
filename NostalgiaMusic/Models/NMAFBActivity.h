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
@property (nonatomic, readonly) int likeCount;
@property (nonatomic, readonly) int commentCount;
@property (copy, nonatomic) NSString *imagePath;
@property (copy, nonatomic, readonly) NSString *message;
@property (copy, nonatomic, readonly) NSString *imageId;
@property (copy, nonatomic, readonly) NSString *timeString;

- (instancetype)initWithPost:(id)post;
- (void)populateActivityImagePath:(id<NMADayDelegate>)dayDelegate;

@end
