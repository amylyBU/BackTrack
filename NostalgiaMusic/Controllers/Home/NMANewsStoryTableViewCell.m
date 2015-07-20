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
    self.story = story;
    
    if(story.headline) {
        self.headlineLabel.text = story.headline;
        self.headlineLabel.font = [UIFont NMA_proximaNovaSemiBoldWithSize:20];
    }
    
    if(story.byline) {
        
        self.bylineLabel.text = [story.byline uppercaseString];
        self.bylineLabel.font = [UIFont NMA_proximaNovaRegularWithSize:13];
        self.bylineLabel.textColor = [UIColor NMA_warmGray];
    }
    
    if(story.snippet) {
        self.summaryTextLabel.text = story.snippet;
        self.summaryTextLabel.font = [UIFont NMA_proximaNovaRegularWithSize:16];
    }
    self.backgroundColor = [UIColor NMA_white];
    
    [self configureDateLabel:story];
    
    self.continueReadingButton.titleLabel.text = @"Continue Reading in the New York Times";
    self.continueReadingButton.titleLabel.font = [UIFont NMA_proximaNovaRegularWithSize:13];
    self.continueReadingButton.titleLabel.textColor = [UIColor NMA_warmGray];
    
    
}

- (void)configureDateLabel:(NMANewsStory *)story {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMdd"];
    NSDate *storyDate = [dateFormatter dateFromString:story.date];
    [dateFormatter setDateFormat:@"LLLL dd"];
    NSString *displayDate = [dateFormatter  stringFromDate:storyDate];
    self.dateLabel.text = [displayDate uppercaseString];
    self.dateLabel.font = [UIFont NMA_proximaNovaRegularWithSize:12];
}

- (IBAction)goToNewYorkTimes {
    NSString *url = [NSString stringWithFormat:self.story.articleURL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
@end
