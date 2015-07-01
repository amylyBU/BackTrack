//
//  NMADatabaseManager.h
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface NMADatabaseManager : NSObject

+ (instancetype)sharedDatabaseMgr;

- (NSArray *)runQueryForYear:(NSString *)year;

@end
