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
@property (nonatomic, readonly, copy) NSString *message;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, readonly, copy) NSString *imageId;
@property (nonatomic, readonly) int likeCount;
@property (nonatomic, readonly) int commentCount;
@property (nonatomic, readonly, copy) NSString *timeString;

- (instancetype)initWithPost:(id)post dayDelegate:(id<NMADayDelegate>)delegate;

@end
