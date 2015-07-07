//
//  NMADay.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMASong.h"
#import "NMAFBActivity.h"
#import "FBSDKGraphRequest.h"
#import "NMARequestManager.h"

//Delegate protocol
@protocol NMADayDelegate
- (void)updatedFBActivity;
@end

@interface NMADay : NSObject
@property (strong, nonatomic, readonly) NSString *year;
@property (strong, nonatomic, readonly) NMASong *song;
@property (strong, nonatomic, readonly) NSArray *FBPosts;
@property (nonatomic, weak) id <NMADayDelegate> delegate;

- (instancetype) initWithYear:(NSString *)year;

@end