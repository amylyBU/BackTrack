//
//  NMARequestManager.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 7/1/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMARequestManager.h"
#import "NMADatabaseManager.h"

@implementation NMARequestManager

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NMARequestManager alloc] init];
    });
    return sharedManager;
}


- (void)getBillBoardSongFromYear:(NSString *)year
                         success:(void (^)(NMABillboardSong *song))success
                         failure:(void (^)(NSError *error))failure {
    NMABillboardSong *billboardSong = [[NMADatabaseManager sharedDatabaseManager] getSongFromYear:year];
    
    if (billboardSong.sqlite3ErrorCode) { // if there exists an error code (error code = nil if db call was successful)
        NSError *error = [[NSError alloc] initWithDomain:@"SQL error or missing database" code:billboardSong.sqlite3ErrorCode userInfo:nil];
        if (failure) {
            failure(error); // TODO: maybe send alert message
        }
    } else { // successful call to database
        if (success) {
            success(billboardSong); // billboardSong can either be nil or an actual song. TODO: show 'no song' UI or search song in itunes api
        }
    }
}

@end
