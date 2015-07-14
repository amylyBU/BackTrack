//
//  NMAFBLike.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/13/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAFBLike.h"

@interface NMAFBLike()
@property (copy, nonatomic, readwrite) NSString *likerName;
@end

@implementation NMAFBLike

- (instancetype)initWithName:(NSString *)likerName {
    
    self = [super self];
    
    if (self) {
        _likerName = likerName;
    }
    
    return self;
}
@end
