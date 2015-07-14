//
//  NMAFBComment.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/13/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMAFBComment : NSObject
@property (copy, nonatomic, readonly) NSString *commenterName;
@property (copy, nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSInteger likeCount;

- (instancetype)initWithName:(NSString *)commenterName
                     message:(NSString *)message
                   likeCount:(NSInteger)likeCount;

@end
