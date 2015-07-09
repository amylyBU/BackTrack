//
//  NMADay.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMADay.h"

@interface NMADay()
@property (strong, nonatomic, readwrite) NSString *year;
@property (strong, nonatomic, readwrite) NMASong *song;
@property (strong, nonatomic, readwrite) NSArray *FBActivities;
@end

@implementation NMADay

#pragma mark - Initializer

- (instancetype) initWithYear:(NSString *)year {
    self = [super init];
    
    if(self) {
        self.year = year; //TODO: check for valid years
        //TODO: initialize song
        [self collectFBPosts];
    }
    
    return self;
}

#pragma mark - Facebook Post Utility

- (void)collectFBPosts {
    NSMutableArray *mutablePosts = [[NSMutableArray alloc] init];
    
    [[NMARequestManager sharedManager]
     requestFBPostsFromDate:self.year
     success:^(NSArray *posts) {
         for(id post in posts) {
             //we are only interested in status and photo updates for now
             NSString *type = [post objectForKey:@"type"];
             if([type isEqual: @"status"] || [type isEqual: @"photo"]) {
                 NSString *message = [post objectForKey:@"message"];
                 NSString *pictureId = [post objectForKey:@"object_id"];
                 NSString *createdTime = [post objectForKey:@"created_time"];
                 NMAFBActivity *FBActivity = [[NMAFBActivity alloc] initWithMessage:message
                                                                    pictureObjectId:pictureId
                                                                        createdTime:createdTime];
                 //We need to make a separate request to get a high res image for the FBActivity
                 [[NMARequestManager sharedManager] requestFBPostPicture:pictureId
                                                                 success:^(NSString *imagePath) {
                                                                     FBActivity.picturePath = imagePath;
                                                                     //Then we need to reload with the image
                                                                     [self.delegate updatedFBActivity];
                                                                 }
                                                                 failure:nil];
                 [mutablePosts addObject:FBActivity];
             }
         }
         self.FBActivities = [mutablePosts copy];
         [self.delegate updatedFBActivity];
     }
     failure:nil];
}

@end
