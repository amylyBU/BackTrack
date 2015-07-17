//
//  NMANewsStoryTableViewCell.m
//  NostalgiaMusic
//
//  Created by Sara Lieto on 7/6/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMANewsStoryTableViewCell.h"
#import "NMANewsStory.h"
#import "UIColor+NMAColors.h"
#import "UIFont+NMAFonts.h"

@implementation NMANewsStoryTableViewCell

- (void)configureCellForStory:(NMANewsStory *)story {
    if(story.headline) {
        self.headlineLabel.text = story.headline;
        self.headlineLabel.font = [UIFont NMA_proximaNovaSemiBoldWithSize:20];
    }
    
    if(story.byline) {
        
        self.bylineLabel.text = [story.byline uppercaseString];
        self.bylineLabel.font = [UIFont NMA_proximaNovaRegularWithSize:13];
    }
    
    if(story.snippet) {
       // NSString *test = [story.snippet substringToIndex:70];
        self.summaryTextLabel.text = story.snippet;
         self.summaryTextLabel.font = [UIFont NMA_proximaNovaRegularWithSize:16];
    }
    self.backgroundColor = [UIColor NMA_white];
    
}

@end
