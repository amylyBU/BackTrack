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

- (void)getNewYorkTimesStory:(NSString *)date
                     success:(void (^)(NSMutableArray *stories))success
                     failure:(void (^)(NSError *error))failure {
    NSString *urlQueryDefault = @"http://api.nytimes.com/svc/search/v2/articlesearch.json?fq=section_name.contains%3A%22Front+Page%22";
    NSString *apiKey = @"dcea47d59f7c08951bc83252867d596d:1:72360000";
    NSString *urlWithStartYear = [urlQueryDefault stringByAppendingString:[NSString stringWithFormat:@"&begin_date=%@", date]];
    NSString *urlWithYearRange = [urlWithStartYear stringByAppendingString:[NSString stringWithFormat:@"&end_date=%@", date]];
    NSString *urlWithAPI = [urlWithYearRange stringByAppendingString:[NSString stringWithFormat:@"&api-key=%@", apiKey]];
    
    NSURL *requestURL = [NSURL URLWithString:urlWithAPI];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    NMANewsStory *story = [[NMANewsStory alloc] init];
    NSMutableArray *stories = [[NSMutableArray alloc] init];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self parseNYTJSON:responseObject intoArray:stories];
        
            success(stories);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
     }];
    
    [operation start];
    
}

- (void)parseNYTJSON:(NSDictionary *)json intoArray:(NSMutableArray *)stories {
    NMANewsStory *story = [[NMANewsStory alloc] init];
    NSDictionary *response = [json objectForKey:@"response"];
    NSDictionary *docs = [response objectForKey:@"docs"];
    for (NSDictionary *item in docs){
        NSMutableArray *images = [item valueForKey:@"multimedia"];
        story.imageLinks = images;
        story.abstract = [item valueForKey:@"abstract"];
        story.headline = [item valueForKey:@"headline"];
        story.headline = [story.headline valueForKey:@"main"];
        story.snippet = [item valueForKey:@"snippet"];
        story.articleURL = [item valueForKey:@"web_url"];
        story.byline = [item valueForKey:@"byline"];
        story.byline = [story.byline valueForKey:@"original"];
        [stories addObject:story];
    }
}
@end
