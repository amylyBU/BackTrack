//
//  NMADay.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NMASong;

//Delegate protocol
@protocol NMADayDelegate
- (void)updatedFBActivity;
@end

@interface NMADay : NSObject
@property (strong, nonatomic, readonly) NMASong *song;
@property (strong, nonatomic, readonly) NSString *year;
@property (weak, nonatomic) id <NMADayDelegate> delegate;
@property (strong, nonatomic, readonly) NSArray *FBActivities;

- (instancetype)initWithYear:(NSString *)year dayDelgate:(id<NMADayDelegate>)dayDelegate;

@end