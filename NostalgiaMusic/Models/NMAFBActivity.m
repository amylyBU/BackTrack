//
//  NMAFBPost.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAFBActivity.h"

@interface NMAFBActivity()
@property (strong, nonatomic, readwrite) NSString *message;
@property (strong, nonatomic, readwrite) NSString *picturePath;
@property (nonatomic, readwrite) NSInteger *likeCount;
@property (nonatomic, readwrite) NSInteger *commentCount;
@property (strong, nonatomic, readwrite) NSString *createdTime;
@end

@implementation NMAFBActivity

#pragma mark - Initializer
- (instancetype) initWithMessage:(NSString *)message
                     picturePath:(NSString *)picturePath
                       likeCount:(NSInteger *)likeCount
                    commentCount:(NSInteger *)commentCount
                            createdTime:(NSString *) createdTime {
    self = [super init];
    
    if(self) {
        self.message = message;
        self.picturePath = picturePath;
        self.likeCount = likeCount;
        self.commentCount = commentCount;
        self.createdTime = createdTime;
    }
    
    return self;
}

@end
