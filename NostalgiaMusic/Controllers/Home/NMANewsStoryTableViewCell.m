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
#import "UIView+NMAView.h"

@implementation NMANewsStoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureUI];
}

- (void)configureUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headlineLabel.font = [UIFont nma_proximaNovaSemiBoldWithSize:20];
    self.bylineLabel.font = [UIFont nma_proximaNovaRegularWithSize:13];
    self.bylineLabel.textColor = [UIColor nma_warmGray];
    self.summaryTextLabel.font = [UIFont nma_proximaNovaRegularWithSize:16];
    self.continueReadingButton.titleLabel.font = [UIFont nma_proximaNovaRegularWithSize:13];
    self.continueReadingButton.titleLabel.textColor = [UIColor nma_warmGray];
    self.dateLabel.font = [UIFont nma_proximaNovaRegularWithSize:12];
    [UIView nma_AddShadow:self.containerView];
}

- (void)configureCellForStory:(NMANewsStory *)story {
    self.story = story;
    if (story.headline) {
        self.headlineLabel.text = [story.headline capitalizedString];
    }
    if (story.byline) {
        self.bylineLabel.text = [story.byline uppercaseString];
    }
    if (story.snippet) {
        self.summaryTextLabel.text = story.snippet;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.minimumLineHeight = 20.0f;
        style.maximumLineHeight = 20.0f;
        NSDictionary *attributtes = @{ NSParagraphStyleAttributeName : style };
        self.summaryTextLabel.attributedText = [[NSAttributedString alloc] initWithString:story.snippet attributes:attributtes];
        [self.summaryTextLabel sizeToFit];
        self.summaryTextLabel.font = [UIFont nma_proximaNovaRegularWithSize:16];
    }
    [self configureDateLabel:story];
    self.continueReadingButton.titleLabel.text = @"Continue Reading in The New York Times";
    [self.continueReadingButton setShowsTouchWhenHighlighted:NO];
}

- (void)configureDateLabel:(NMANewsStory *)story {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMdd"];
    NSDate *storyDate = [dateFormatter dateFromString:story.date];
    [dateFormatter setDateFormat:@"LLLL dd"];
    NSString *displayDate = [dateFormatter  stringFromDate:storyDate];
    self.dateLabel.text = [displayDate uppercaseString];
}

- (IBAction)goToNewYorkTimes {
    NSString *url = [NSString stringWithFormat:@"%@", self.story.articleURL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (IBAction)share:(UIButton *)sender {
    NSMutableArray *sharingItems = [[NSMutableArray alloc] init];
    
    if (self.story.articleURL) {
        [sharingItems addObject:self.story.articleURL];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self.delegate presentViewController:activityController animated:YES completion:nil];
}
@end
