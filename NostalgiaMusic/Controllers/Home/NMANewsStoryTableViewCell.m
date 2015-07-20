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

@implementation NMANewsStoryTableViewCell

- (void)configureCellForStory:(NMANewsStory *)story {
    if(story.headline) {
        self.headlineLabel.text = story.headline;
    }
    
    if(story.byline) {
        self.bylineLabel.text = story.byline;
    }
    
    if(story.snippet) {
        self.summaryTextView.text = story.snippet;
    }
    
    self.backgroundColor = [UIColor NMA_white];
}

@end
