//
//  NMANewsArticle.h
//  NostalgiaMusic
//
//  Created by Sara Lieto on 7/2/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMANewsStory : NSObject
@property (copy, nonatomic) NSString *headline;
@property (copy, nonatomic) NSString *abstract;
@property (copy, nonatomic) NSString *snippet;
@property (copy, nonatomic) NSString *articleURL;
@property (copy, nonatomic) NSString *byline;
@property (strong, nonatomic) NSMutableArray *imageLinks;
@property (copy, nonatomic) NSString *date;

@end
