//
//  NMARequestManager.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/1/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMARequestManager.h"
#import "NMADatabaseManager.h"
#import <AFNetworking/AFNetworking.h>
#import "NMANewsStory.h"

@implementation NMARequestManager

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NMARequestManager alloc] init];
    });
    return sharedManager;
}


- (void)getSongFromYear:(NSString *)year
                         success:(void (^)(NMASong *song))success
                         failure:(void (^)(NSError *error))failure {
    NMASong *song = [[NMADatabaseManager sharedDatabaseManager] getSongFromYear:year];
    
    if (song) {
        if (success) {
            success(song);
        }
    } else {
        if (failure) {
            NSError *error = [[NSError alloc] init];
            failure(error);
        }
    }
}

- (void)getNewYorkTimesStory:(NSString *)year
                     success:(void (^)(NMANewsStory *story))success
                     failure:(void (^)(NSError *error))failure {
    NSString *urltest = @"http://api.nytimes.com/svc/search/v2/articlesearch.json?fq=section_name.contains%3A%22Front+Page%22&begin_date=20000623&end_date=20000623&api-key=dcea47d59f7c08951bc83252867d596d:1:72360000";
    NSURL *requestURL = [NSURL URLWithString:urltest];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    NMANewsStory *story = [[NMANewsStory alloc] init];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *json = responseObject;
            NSLog(@"JSON: %@", responseObject);
            success(story);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
     }];
    
    [operation start];
    
}
@end
