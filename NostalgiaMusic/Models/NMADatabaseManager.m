//
//  NMADatabaseManager.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/30/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMADatabaseManager.h"
#import "NMABillBoardSong.h"

@interface NMADatabaseManager ()

@property (strong, nonatomic) NSMutableArray *queryResultsArray;

@end

@implementation NMADatabaseManager

static NMADatabaseManager *_database;

#pragma mark - Singleton

+ (instancetype)sharedDatabaseMgr {
    static id sharedDB = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDB = [[NMADatabaseManager alloc] init];
    });
    return sharedDB;
}

- (NSArray *)runQueryForYear:(NSString *)year {
    self.queryResultsArray = [[NSMutableArray alloc] init];
    sqlite3 *database;
    
    NSString *dbFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/tracks.db"];
    if (sqlite3_open([dbFilePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sql = [[NSString stringWithFormat:@"SELECT * FROM tracks WHERE year_peaked = %@", year] UTF8String];
        sqlite3_stmt *selectStatement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL) == SQLITE_OK) {

            while (sqlite3_step(selectStatement) == SQLITE_ROW) {
                NMABillBoardSong *newSong = [[NMABillBoardSong alloc] init];
                
                char *yearPeaked = (char *) sqlite3_column_text(selectStatement, 2);
                newSong.yearPeaked = [[NSString alloc] initWithUTF8String:yearPeaked];
                char *yearlyRank = (char *) sqlite3_column_text(selectStatement, 3);
                newSong.yearlyRank = [[NSString alloc] initWithUTF8String:yearlyRank];
                char *artistAsAppearsOnLabel = (char *) sqlite3_column_text(selectStatement, 10);
                newSong.artistAsAppearsOnLabel = [[NSString alloc] initWithUTF8String:artistAsAppearsOnLabel];
                char *title = (char *) sqlite3_column_text(selectStatement, 13);
                newSong.title = [[NSString alloc] initWithUTF8String:title];
                
                [self.queryResultsArray addObject:newSong];
            }
        }
        sqlite3_finalize(selectStatement); // destroy prepared statement object
    }
    sqlite3_close(database); // close database
    return [self.queryResultsArray copy];
}

@end
