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
#import "NMAFBActivity.h"
#import "FBSDKGraphRequest.h"

@implementation NMARequestManager

#pragma mark - Singleton

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NMARequestManager alloc] init];
    });
    return sharedManager;
}

#pragma mark - NYTimes Web Calls

- (void)getNewYorkTimesStory:(NSString *)date
                      onYear:(NSString *)year
                     success:(void (^)(NMANewsStory *story))success
                     failure:(void (^)(NSError *error))failure {

    NSURL *requestURL = [NSURL URLWithString:[self configureQueryString:date withYear:year]];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *stories = [self parseNYTJSON:responseObject];
        success([stories objectAtIndex:0]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get NYT information");
        failure(nil);
     }];

    [operation start];

}

- (NSString *)configureQueryString:(NSString *)date withYear:(NSString *)year{
    NSString *urlQueryDefault = @"http://api.nytimes.com/svc/search/v2/articlesearch.json?fq=news_desk('Foreign')&sort=oldest";
    NSString *apiKey = @"dcea47d59f7c08951bc83252867d596d:1:72360000";
    NSString *dateWithYear = [year stringByAppendingString:date];
    NSString *urlWithStartYear = [urlQueryDefault stringByAppendingString:[NSString stringWithFormat:@"&begin_date=%@", dateWithYear]];
    NSString *urlWithYearRange = [urlWithStartYear stringByAppendingString:[NSString stringWithFormat:@"&end_date=%@", dateWithYear]];
    NSString *urlWithAPI = [urlWithYearRange stringByAppendingString:[NSString stringWithFormat:@"&api-key=%@", apiKey]];
    return urlWithAPI;
}

- (NSMutableArray *)parseNYTJSON:(NSDictionary *)json {
    NSMutableArray *stories = [[NSMutableArray alloc] init];
    NMANewsStory *story = [[NMANewsStory alloc] init];
    NSDictionary *response = [json objectForKey:@"response"];
    NSDictionary *docs = [response objectForKey:@"docs"];
    if (docs.count > 3) {
        for (NSDictionary *item in docs) {
            NSMutableArray *images = [item valueForKey:@"multimedia"];
            story.imageLinks = images;
            story.abstract = [self resolveNSNullToNil:[item valueForKey:@"abstract"]];
            NSMutableArray *headlines = [self resolveNSNullToNil:[item valueForKey:@"headline"]];
            if (headlines.count) {
                story.headline = [self resolveNSNullToNil:[headlines valueForKey:@"main"]];
            }
            story.snippet = [self resolveNSNullToNil:[item valueForKey:@"snippet"]];
            story.articleURL = [self resolveNSNullToNil:[item valueForKey:@"web_url"]];
            NSMutableArray *bylines = [self resolveNSNullToNil:[item valueForKey:@"byline"]];
            if (bylines.count) {
                story.byline = [self resolveNSNullToNil:[bylines valueForKey:@"original"]];
            }
            [stories addObject:story];
        }
    }
    if (stories.count) {
        return stories;
    } else {
        story.headline = @"no news found";
        [stories addObject:story];
        return stories;
    }
}

- (id)resolveNSNullToNil:(id)objectForKey {
    return [NSNull null] == objectForKey ? nil : objectForKey;
}

#pragma mark - NMASong Web Calls

- (void)getiTunesMusicForSong:(NMASong *)song
                      success:(void (^)(NMASong *songWithPreview))success
                      failure:(void (^)(NSError *error))failure {

    NSString *searchTerm = [NSString stringWithFormat:@"%@ %@", song.title, song.artistAsAppearsOnLabel];
    NSDictionary *parameters = @{ @"term":searchTerm, @"media":@"music", @"entity":@"song" };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/JSON"];

    NSString *searchString = @"https://itunes.apple.com/search";

    [manager GET:searchString
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSArray *resultsArray = [responseObject objectForKey:@"results"];
             for (NSDictionary *result in resultsArray) {
                 song.previewURL = [result objectForKey:@"previewUrl"];
                 song.albumImageUrl600x600 = [NSURL URLWithString:[[result objectForKey:@"artworkUrl100"] stringByReplacingOccurrencesOfString:@"100x100" withString:@"600x600"]];
                 song.trackViewUrl = [NSURL URLWithString:[result objectForKey:@"trackViewUrl"]];
                 break;
             }
             if (success) {
                 success(song);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure (error); //TODO: handle error
             }
         }
     ];
}

#pragma mark - Facebook Requests

- (void)requestFBActivitiesFromDate:(NSString *)year
                        dayDelegate:(id<NMADayDelegate>)dayDelegate
                            success:(void (^)(NSArray *FBActivities))success
                            failure:(void (^)(NSError *error))failure {
    //Facebook wants its dates in UTC, so make sure we set local boundaries...
    NSDate *targetDateStart = [self getLocalDate:year startOfDay:YES];
    NSDate *targetDateEnd = [self getLocalDate:year startOfDay:NO];

    //...Before formatting in UTC time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *sinceTime = [dateFormatter stringFromDate:targetDateStart];
    NSString *untilTime = [dateFormatter stringFromDate:targetDateEnd];

    NSString *path = @"/me/posts";
    NSDictionary *params = @{
                             @"since" : sinceTime,
                             @"until" : untilTime
                             };
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:path
                                                                   parameters:params
                                                                   HTTPMethod:@"GET"];

    NSMutableArray *mutableFBActivities = [[NSMutableArray alloc] init];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            NSArray *posts = result[@"data"];
            if (posts) {
                for (NSDictionary *post in posts) {
                    NSString *type = post[@"type"];
                    if ([type isEqual:@"status"] || [type isEqual:@"photo"]) {
                        NMAFBActivity *fbActivity = [[NMAFBActivity alloc] initWithPost:post];
                        [fbActivity populateActivityImagePath:dayDelegate];
                        NSDictionary *likesContainer = post[@"likes"];
                        [fbActivity populateActivityLikes:likesContainer dayDelegate:dayDelegate];
                        NSDictionary *commentsContainer = post[@"comments"];
                        [fbActivity populateActivityComments:commentsContainer dayDelegate:dayDelegate];
                        [mutableFBActivities addObject:fbActivity];
                    }
                }
                success([mutableFBActivities copy]);
            }
    }];
}

- (void)requestFBActivityImage:(NSString *)imageId
                       success:(void (^)(NSString *imagePath))success
                       failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"/%@", imageId];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:path
                                                                   parameters:nil
                                                                   HTTPMethod:@"GET"];

    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        NSArray *imageVersions = [result objectForKey:@"images"];
        if (imageVersions) {
            NSString *imagePath = [imageVersions[0] objectForKey:@"source"];
            success(imagePath);
        }
    }];
}

- (void)requestFBActivityResponses:(NSString *)nextLink
                       dayDelegate:(id<NMADayDelegate>)dayDelegate
                           success:(void (^)(NSDictionary *nextLikesContainer))success
                           failure:(void (^)(NSError *error))failure {
    //https://graph.facebook.com/endpoint
    NSString *startPoint = @"https://graph.facebook.com"; //TODO: this is not a good way to do this
    NSString *endPoint = [nextLink substringFromIndex:NSMaxRange([nextLink rangeOfString:startPoint])];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:endPoint
                                                                   parameters:nil
                                                                   HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (result[@"data"] && result[@"paging"]) {
            success(result);
        }
    }];
}

#pragma mark - Format Utility

///@discussion if startOfDay, the time of the date is 00:00:00am, else its 11:59:59pm (the end of the day)
- (NSDate *)getLocalDate:(NSString *)year
              startOfDay:(BOOL)start {
    NSDateComponents *presentDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                              fromDate:[NSDate date]];

    NSDateComponents *targetDateComponents = [[NSDateComponents alloc] init];
    targetDateComponents.year = [year integerValue];
    targetDateComponents.month = presentDateComponents.month;
    targetDateComponents.day = presentDateComponents.day;
    targetDateComponents.hour = (start ? 0 : 23);
    targetDateComponents.minute = (start ? 0 : 59);
    targetDateComponents.second = (start ? 0 : 59);
    targetDateComponents.timeZone = [NSTimeZone localTimeZone];
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    return [gregorianCal dateFromComponents:targetDateComponents];
}

- (void)getSongFromYear:(NSString *)year
                success:(void (^)(NMASong *song))success
                failure:(void (^)(NSError *error))failure {
    NMASong *song = [[NMADatabaseManager sharedDatabaseManager] getSongFromYear:year];

    if (song) {
        if (success) {
            [self getiTunesMusicForSong:song
                                success:success
                                failure:^(NSError *error) {
                                    NSLog(@"can't find song on itunes"); //TODO: handle error
                                }];
        }
    } else {
        if (failure) {
            NSError *error = [[NSError alloc] init];
            failure(error); //TODO: handle error
        }
    }
}

@end
