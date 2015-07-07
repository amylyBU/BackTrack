//
//  NMAFBPost.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMAFBActivity : NSObject
@property (strong, nonatomic, readonly) NSString *message;
@property (strong, nonatomic, readonly) NSString *picturePath;
@property (nonatomic, readonly) NSInteger *likeCount;
@property (nonatomic, readonly) NSInteger *commentCount;
@property (strong, nonatomic, readonly) NSString *createdTime;

- (instancetype) initWithMessage:(NSString *)message
                     picturePath:(NSString *)picturePath
                       likeCount:(NSInteger *)likeCount
                    commentCount:(NSInteger *)commentCount
                            createdTime:(NSString *)createdTime;
@end
