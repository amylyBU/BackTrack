//
//  NMAFBComment.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/13/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAFBComment.h"

@interface NMAFBComment()
@property (copy, nonatomic, readwrite) NSString *commenterName;
@property (copy, nonatomic, readwrite) NSString *message;
@property (nonatomic, readwrite) NSInteger likeCount;
@end

@implementation NMAFBComment

- (instancetype)initWithName:(NSString *)commenterName
                     message:(NSString *)message
                   likeCount:(NSInteger)likeCount {
    
    self = [super self];
    
    if (self) {
        _commenterName = commenterName;
        _message = message;
        _likeCount = likeCount;
    }
    
    return self;
}

@end
