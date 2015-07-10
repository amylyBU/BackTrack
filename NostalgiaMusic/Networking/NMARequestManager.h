//
//  NMARequestManager.h
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/1/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMASong.h"
#import "NMANewsStory.h"
#import "NMAFBActivity.h"

@interface NMARequestManager : NSObject

+ (instancetype)sharedManager;

- (void)getSongFromYear:(NSString *)year
                success:(void (^)(NMASong *song))success
                failure:(void (^)(NSError *error))failure;

- (void)getiTunesMusicForSong:(NMASong *)song
                      success:(void (^)(NMASong *songWithPreview))success
                      failure:(void (^)(NSError *error))failure;

- (void)getNewYorkTimesStory:(NSString *)date
                      onYear:(NSString *)year
                     success:(void (^)(NMANewsStory *story))success
                     failure:(void (^)(NSError *error))failure;

- (void)requestFBActivitiesFromDate:(NSString *)year
                       dayDelegate:(id<NMADayDelegate>)dayDelegate
                           success:(void (^)(NSArray *FBActivities))success
                           failure:(void (^)(NSError *error))failure;

- (void)requestFBActivityImage:(NSString *)imageId
                       success:(void (^)(NSString *imagePath))success
                       failure:(void (^)(NSError *error))failure;

@end
