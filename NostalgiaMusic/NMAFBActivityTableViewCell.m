//
//  NMAFBActivityTableViewCell.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/7/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMAFBActivityTableViewCell.h"
#import "NMAFBLike.h"
#import "NMAFBComment.h"

#import "UIColor+NMAColors.h"
#import "UIFont+NMAFonts.h"
#import "UIImage+NMAImages.h"
#import "UIView+NMAView.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface NMAFBActivityTableViewCell()

@property (nonatomic) NSInteger displayedCommentCount;

@end

static const NSInteger kCommentAddRate = 10;
static const NSInteger kLikeLimit = 5;
static const float kMainPageAspectRatio = 0.667f;
static const NSInteger kCommentParagraphSpacing = 7;

@implementation NMAFBActivityTableViewCell

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    self.commentThreadLabel.textColor = [UIColor nma_almostBlack];
    self.continueLabel.textColor = [UIColor nma_lightGray];
    [self.viewMoreButton setTitleColor:[UIColor nma_lightGray] forState:UIControlStateNormal];
    [self.likesButton setTitleColor:[UIColor nma_darkGray] forState:UIControlStateNormal];
    [self.commentsButton setTitleColor:[UIColor nma_darkGray] forState:UIControlStateNormal];
    self.backgroundColor = [UIColor clearColor];
    self.displayedCommentCount = 0;
    self.commentThreadLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
}

#pragma mark - IBActions

- (IBAction)viewMoreComments:(UIButton *)sender {
    [self.delegate loadMoreComments:kCommentAddRate currentCount:self.displayedCommentCount];
}

- (IBAction)closeFullPost:(UIButton *)sender {
    [self.delegate closeModalDialog];
}

- (IBAction)share:(UIButton *)sender {
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (self.messageLabel.text) {
        [sharingItems addObject:self.messageLabel.text];
    }
    
    if (self.imageView.image) {
        [sharingItems addObject:self.imageView.image];
    }
    
    [self.delegate shareItems:sharingItems];
}

#pragma mark - Cell Configuration

- (void)configureCellWithActivity:(NMAFBActivity *)fbActivity collapsed:(BOOL)collapsed withShadow:(BOOL)shadow {
    if (!fbActivity) {
        return;
    }
    
    if (fbActivity.timeString) {
        self.timeLabel.text = fbActivity.timeString;
    }
    
    [self constructFullPost:fbActivity collapsed:collapsed];
    
    if (fbActivity.hasImage) {
        if (fbActivity.imagePath) {
            NSURL *imageURL = [NSURL URLWithString:fbActivity.imagePath];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage *postImage = [UIImage imageWithData:imageData];
            [self setPostImage:postImage];
        } else {
            [self setPostImage:[UIImage nma_defaultImage]];
        }
    } else {
        self.collapseImageConstraint.priority = 999;
    }
    
    if (shadow) {
        [UIView nma_AddShadow:self.shadowView];
    } else {
        self.shadowView.hidden = YES;
    }
}

- (void)setCollapsedCellState:(BOOL)isCollapsed withActivity:(NMAFBActivity *)fbActivity {
    self.isCollapsed = isCollapsed;
    int messageLineCount = self.isCollapsed ? 2 : 0;
    self.messageLabel.numberOfLines = messageLineCount;
    
    self.closeButton.hidden = isCollapsed;
    self.likeCreditsLabel.hidden = isCollapsed;
    self.timeLabel.hidden = !isCollapsed;
    self.timeRibbonView.hidden = !isCollapsed;
    self.commentsButton.hidden = !isCollapsed;
    self.likesButton.hidden = !isCollapsed;
    
    if (isCollapsed) {
        self.continueLabel.text = @"...Continue Reading";
        self.viewMoreButton.hidden = YES;
        [self configureCollapseConstraints:fbActivity];
    } else {
        NSAttributedString *attributedEmpty = [[NSAttributedString alloc] initWithString:@""];
        self.continueLabel.attributedText = attributedEmpty;
        [self configureExpandConstraints:fbActivity];
    }
}

- (void)configureCollapseConstraints:(NMAFBActivity *)fbActivity {
    self.collapseContinueToToolsConstraint.priority = 999;
    self.collapseMessageToCreditsConstraint.priority = 1;
    self.collapseCloseButtonConstraint.priority = 999;
    
    if (!fbActivity.imagePath) {
        self.collapseImageAndMessageOverlapConstraint.priority = 1;
        self.collapseMessageTopToViewConstraint.priority = 1;
    }
}

- (void)configureExpandConstraints:(NMAFBActivity *)fbActivity {
    self.collapseContinueToToolsConstraint.priority = 1;
    self.collapseMessageToCreditsConstraint.priority = 999;
    self.collapseCloseButtonConstraint.priority = 1;
    
    if (!fbActivity.imagePath) {
        self.collapseImageAndMessageOverlapConstraint.priority = 999;
        self.collapseMessageTopToViewConstraint.priority = 999;
    }
    
    if (fbActivity.likes.count == 0) {
        self.collapseLikesToCommentsConstraint.priority = 999;
    }
    
    if (fbActivity.comments.count == 0) {
        self.collapseCommentsToToolsConstraint.priority = 999;
    }
}

#pragma mark - Image Setting

- (void)setImageWidth:(CGFloat)imageWidth trueAspectRatio:(BOOL)useTrueAspectRatio withActivity:(NMAFBActivity*)fbActivity {
    CGRect frame = CGRectMake(0, 0, imageWidth, self.postImageView.bounds.size.height);
    self.postImageView.frame = frame;
    
    if (fbActivity.imagePath) {
        NSURL *imageURL = [NSURL URLWithString:fbActivity.imagePath];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *postImage = [UIImage imageWithData:imageData];
        self.collapseImageConstraint.priority = 1;
        [self setImageViewDimensions:postImage trueAspectRatio:useTrueAspectRatio];
    }
}

- (void)setImageViewDimensions:(UIImage *)targetImage trueAspectRatio:(BOOL)useTrueAspectRatio {
    float heightToWidthRatio = targetImage.size.height / targetImage.size.width;
    float imageAspectRatio = useTrueAspectRatio ? heightToWidthRatio : kMainPageAspectRatio;
    float newViewHeight = imageAspectRatio * CGRectGetWidth(self.postImageView.frame);
    self.imageHeightConstraint.constant = newViewHeight;
}

- (void)setPostImage:(UIImage *)image {
    self.collapseImageConstraint.priority = 1;
    [self setImageViewDimensions:image trueAspectRatio:!self.isCollapsed];
    [self.postImageView setImage:image];
    [self layoutIfNeeded];
}

#pragma mark - Post Construction

- (void)constructFullPost:(NMAFBActivity *)fbActivity collapsed:(BOOL)collapsed {
    [self setCollapsedCellState:collapsed withActivity:fbActivity];
    
    NSAttributedString *messageText = fbActivity.message ?
    [[NSAttributedString alloc] initWithString:fbActivity.message] :
    [[NSAttributedString alloc] initWithString:@""];
    
    self.messageLabel.attributedText = messageText;
    
    if (!collapsed) {
        self.likeCreditsLabel.attributedText = [self constructLikeCredits:fbActivity];
        self.commentThreadLabel.attributedText = [self constructCommentThread:fbActivity];
    }
    
    NSString *likeCountText = [@(fbActivity.likes.count) stringValue];
    [self.likesButton setTitle:likeCountText forState:UIControlStateNormal];
    NSString *commentCountText = [@(fbActivity.comments.count) stringValue];
    [self.commentsButton setTitle:commentCountText forState:UIControlStateNormal];
    [self.messageLabel sizeToFit];
}

#pragma mark - Like Construction

- (NSAttributedString *)constructLikeCredits:(NMAFBActivity *)fbActivity {
    NSMutableAttributedString *likeCreditString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    if (fbActivity.likes.count == 0) {
        return likeCreditString;
    }
    
    if (fbActivity.likes.count == 1) {
        NMAFBLike *like = fbActivity.likes[0];
        [self appendLike:like to:likeCreditString index:0 limit:1 lastCommaSpacer:3];
        
        NSAttributedString *attributedEnd = [[NSAttributedString alloc] initWithString:@" likes this post."];
        [likeCreditString appendAttributedString:attributedEnd];
        
    } else if (fbActivity.likes.count > kLikeLimit) {
        for (NSInteger likeIndex = 0; likeIndex < kLikeLimit; likeIndex++ ) {
            NMAFBLike *like = fbActivity.likes[likeIndex];
            [self appendLike:like to:likeCreditString index:likeIndex limit:kLikeLimit lastCommaSpacer:1];
        }
       
        NSInteger remainingLikes = fbActivity.likes.count - kLikeLimit;
        [self endCredits:likeCreditString withManyLikes:remainingLikes];
        
    } else {
        for (NSInteger likeIndex = 0; likeIndex < fbActivity.likes.count - 1; likeIndex++ ) {
            NMAFBLike *like = fbActivity.likes[likeIndex];
            [self appendLike:like to:likeCreditString index:likeIndex limit:fbActivity.likes.count lastCommaSpacer:2];
        }
        
        NMAFBLike *finalLike = fbActivity.likes[fbActivity.likes.count - 1];
        [self endCredits:likeCreditString withOneLike:finalLike];
    }
    
    return likeCreditString;
}

- (void)endCredits:(NSMutableAttributedString *)likeCreditString withManyLikes:(NSInteger)remainingLikes {
    NSString *peopleOrPerson = remainingLikes > 1 ? @"people" : @"person";
    NSString *likeOrLikes = remainingLikes > 1 ? @"like" : @"likes";
    NSAttributedString *attributedAnd = [[NSAttributedString alloc] initWithString:@"and "];
    [likeCreditString appendAttributedString:attributedAnd];
    NSAttributedString *attributedRemainingLikes = [self attributedRemainingLikes:remainingLikes];
    [likeCreditString appendAttributedString:attributedRemainingLikes];
    NSString *creditEnd = [NSString stringWithFormat:@" other %@ %@ this post.", peopleOrPerson, likeOrLikes];
    NSAttributedString *attributedCreditEnd = [[NSAttributedString alloc] initWithString:creditEnd];
    [likeCreditString appendAttributedString:attributedCreditEnd];
}

- (void)endCredits:(NSMutableAttributedString *)likeCreditString withOneLike:(NMAFBLike *)finalLike {
    NSAttributedString *attributedAnd = [[NSAttributedString alloc] initWithString:@"and "];
    [likeCreditString appendAttributedString:attributedAnd];
    NSAttributedString *attributedFinalLike = [self boldedString:finalLike.likerName];
    [likeCreditString appendAttributedString:attributedFinalLike];
    NSAttributedString *attributedEnd = [[NSAttributedString alloc] initWithString:@" like this post."];
    [likeCreditString appendAttributedString:attributedEnd];
}

- (void)appendLike:(NMAFBLike *)like
                to:(NSMutableAttributedString *)likeCreditString
             index:(NSInteger)likeIndex
             limit:(NSInteger)likeLimit
   lastCommaSpacer:(NSInteger)lastCommaSpacer {
    NSAttributedString *boldedString = [self boldedString:like.likerName];
    [likeCreditString appendAttributedString:boldedString];
    NSString *spacing = likeIndex + lastCommaSpacer < likeLimit ? @", " : @" ";
    NSAttributedString *attributedSpacing = [[NSAttributedString alloc] initWithString:spacing];
    [likeCreditString appendAttributedString:attributedSpacing];
}

- (NSAttributedString *)attributedRemainingLikes:(NSInteger)remainingLikes {
    NSString *number = @"";
    NSString *suffix = @"";
    NSInteger billion = 1000000000;
    NSInteger million = 1000000;
    NSInteger thousand = 1000;
    if (remainingLikes >= billion) {
        NSInteger reducedNumber = remainingLikes / billion;
        number = [@(reducedNumber) stringValue];
        suffix = @" billion";
    } else if (remainingLikes >= million) {
        NSInteger reducedNumber = remainingLikes / million;
        number = [@(reducedNumber) stringValue];
        suffix = @" million";
    } else if (remainingLikes >= thousand) {
        NSInteger reducedNumber = remainingLikes / thousand;
        number = [@(reducedNumber) stringValue];
        suffix = @" thousand";
    } else {
        number = [@(remainingLikes) stringValue];
        suffix = @"";
    }
    
    NSString *formattedRemainingLikes = [NSString stringWithFormat:@"%@%@",number, suffix];
    NSDictionary *formattedRemainingLikesAttributes = @{ NSForegroundColorAttributeName : [UIColor nma_lightGray],
                                                         NSFontAttributeName : [UIFont nma_proximaNovaBoldWithSize:15]};
    NSAttributedString *attributedRemainingLikes = [[NSAttributedString alloc] initWithString:formattedRemainingLikes
                                                                                   attributes:formattedRemainingLikesAttributes];
    
    return attributedRemainingLikes;
}

#pragma mark - Comment Construction

- (NSMutableAttributedString *)constructCommentThread:(NMAFBActivity *)fbActivity {
    NSMutableAttributedString *commentThreadString = [self.commentThreadLabel.attributedText mutableCopy];
    
    NSInteger currentDisplayed = self.displayedCommentCount > kCommentAddRate ? self.displayedCommentCount : kCommentAddRate;
    [self appendComments:fbActivity toThread:commentThreadString amount:currentDisplayed];
    
    return commentThreadString;
}

- (void)updateCommentThread:(NMAFBActivity *)fbActivity {
    if (!self.isCollapsed) {
        NSMutableAttributedString *commentThread = [[NSMutableAttributedString alloc] initWithAttributedString:self.commentThreadLabel.attributedText];
        self.commentThreadLabel.attributedText = [self appendComments:fbActivity
                                                             toThread:commentThread
                                                               amount:kCommentAddRate];
    }
}

- (NSMutableAttributedString *)appendComments:(NMAFBActivity *)fbActivity
                                     toThread:(NSMutableAttributedString *)commentThreadString
                                       amount:(NSInteger)amount {
    BOOL finalComments = self.displayedCommentCount + amount >= fbActivity.comments.count;
    NSInteger appendAmount = finalComments ? fbActivity.comments.count - self.displayedCommentCount : amount;
    
    for (NSInteger appendIndex = 0; appendIndex < appendAmount; appendIndex++) {
        NMAFBComment *comment = fbActivity.comments[self.displayedCommentCount + appendIndex];
        [self appendComment:comment to:commentThreadString];
    }
    
    self.displayedCommentCount += appendAmount;
    self.viewMoreButton.hidden = finalComments || self.isCollapsed;
    
    if (self.viewMoreButton.hidden) {
        self.collapseViewMoreHeightConstraint.priority = 999;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphSpacing:kCommentParagraphSpacing];
    NSDictionary *commentAttributes = @{ NSParagraphStyleAttributeName : paragraphStyle};
    [commentThreadString addAttributes:commentAttributes range:NSMakeRange(0, commentThreadString.length)];
    
    return commentThreadString;
}

- (void)appendComment:(NMAFBComment *)comment
                   to:(NSMutableAttributedString *)commentThreadString {
    NSAttributedString *attributedName = [self boldedString:comment.commenterName];
    [commentThreadString appendAttributedString:attributedName];
    NSAttributedString *attributedSpacer = [[NSAttributedString alloc] initWithString:@"  "];
    [commentThreadString appendAttributedString:attributedSpacer];
    NSAttributedString *attribuedComment = [[NSAttributedString alloc] initWithString:comment.message];
    [commentThreadString appendAttributedString:attribuedComment];
    NSAttributedString *attributedNewline = [[NSAttributedString alloc] initWithString:@"\n"];
    [commentThreadString appendAttributedString:attributedNewline];
}

- (NSAttributedString *)boldedString:(NSString *)stringToBold {
    NSDictionary *nameAttributes = @{ NSFontAttributeName : [UIFont nma_proximaNovaBoldWithSize:15]};
    NSAttributedString *attributedName = [[NSAttributedString alloc] initWithString:stringToBold
                                                                         attributes:nameAttributes];
    
    return attributedName;
}

@end
