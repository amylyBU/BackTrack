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
    static id sharedMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMgr = [[NMARequestManager alloc] init];
    });
    return sharedMgr;
}


- (void)getBillBoardSongFromYear:(NSString *)year
                         success:(void (^)(NMABillBoardSong *song))success
                         failure:(void (^)(NSError *error))failure {
    if (success) {
        NSArray *allSongsFromYear = [[NMADatabaseManager sharedDatabaseMgr] runQueryForYear:year];
        NSUInteger randomIndex = arc4random() % [allSongsFromYear count];
        dispatch_async(dispatch_get_main_queue(), ^ {
            success(allSongsFromYear[randomIndex]);
        });
    } else {
        if (failure) {
            //TODO: handle error
        }
    }
}

@end
