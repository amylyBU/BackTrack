//
//  NMAFBLike.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/13/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMAFBLike : NSObject
@property (copy, nonatomic, readonly) NSString *likerName;

- (instancetype)initWithName:(NSString *)likerName;

@end
