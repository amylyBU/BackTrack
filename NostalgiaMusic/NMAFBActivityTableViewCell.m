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
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+NMAColors.h"
#import "UIFont+NMAFonts.h"
#import "UIImage+NMAImages.h"

@interface NMAFBActivityTableViewCell()

@property (nonatomic) NSInteger displayedCommentCount;

@end

static const NSInteger kCommentAddRate = 10;
static const NSInteger kLikeLimit = 5;
static const float kMainPageAspectRatio = 0.667f;
static const NSInteger kCommentParagraphSpacing = 7;

@implementation NMAFBActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    self.messageLabel.textColor = [UIColor NMA_almostBlack];
    self.likeCreditsLabel.textColor = [UIColor NMA_almostBlack];
    self.commentThreadLabel.textColor = [UIColor NMA_almostBlack];
    self.continueLabel.textColor = [UIColor NMA_lightGray];
    [self.viewMoreButton setTitleColor:[UIColor NMA_lightGray] forState:UIControlStateNormal];
    [self.likesButton setTitleColor:[UIColor NMA_darkGray] forState:UIControlStateNormal];
    [self.commentsButton setTitleColor:[UIColor NMA_darkGray] forState:UIControlStateNormal];
    self.backgroundColor = [UIColor clearColor];
}

- (void)configureCell:(BOOL)collapsed withShadow:(BOOL)shadow {
    if (!self.fbActivity) {
        return;
    }
    
    if (self.fbActivity.timeString) {
        self.timeLabel.text = self.fbActivity.timeString;
    }
    
    [self constructFullPost:self.fbActivity collapsed:collapsed];
    
    if (self.fbActivity.hasImage) {
        if (self.fbActivity.imagePath) {
            NSURL *imageURL = [NSURL URLWithString:self.fbActivity.imagePath];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage *postImage = [UIImage imageWithData:imageData];
            [self setPostImage:postImage];
        } else {
            [self setPostImage:[UIImage NMA_defaultImage]];
        }
    } else {
        self.collapseImageConstraint.priority = 999;
    }
    
    if (shadow) {
        //Add a shadow to the bottom of the message view
        CGFloat offset = 4;
        CGFloat overlap = self.heightOfOverlapConstraint.constant;
        CGRect templateRect = self.messageView.bounds;
        
        CGFloat rectHeight = self.postImageView.image ? templateRect.size.height + self.postImageView.bounds.size.height + overlap: templateRect.size.height;
        CGFloat templateY = self.postImageView.image ?
        self.messageView.bounds.origin.y - self.postImageView.bounds.size.height - overlap :
            templateRect.origin.y;
        
        CGRect shadowRect = CGRectMake(templateRect.origin.x - offset, templateY, templateRect.size.width + offset, rectHeight);
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:shadowRect];
        self.messageView.layer.masksToBounds = NO;
        self.messageView.layer.shadowColor = [UIColor NMA_darkGray].CGColor;
        self.messageView.layer.shadowRadius = offset;
        self.messageView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.messageView.layer.shadowOpacity = 0.7f;
        [self setNeedsLayout];
        self.messageView.layer.shadowPath = shadowPath.CGPath;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.messageView.layer.shadowOpacity = 0.0f;
}

- (void)setCollapsedCellState:(BOOL)isCollapsed {
    self.collapsed = isCollapsed;
    int messageLineCount = self.collapsed ? 2 : 0;
    self.messageLabel.numberOfLines = messageLineCount;
    
    self.closeButton.hidden = isCollapsed;
    self.timeLabel.hidden = !isCollapsed;
    self.timeRibbonView.hidden = !isCollapsed;
    self.commentsButton.hidden = !isCollapsed;
    self.likesButton.hidden = !isCollapsed;
    
    NSAttributedString *attributedEmpty = [[NSAttributedString alloc] initWithString:@""];
    if (isCollapsed) {
        self.continueLabel.text = @"...Continue Reading";
        self.collapseContinueToToolsConstraint.priority = 999;
        self.collapseMessageToCreditsConstraint.priority = 1;
        self.collapseCloseButtonConstraint.priority = 999;
        
        if (!self.fbActivity.imagePath) {
            self.collapseImageAndMessageOverlapConstraint.priority = 1;
            self.collapseMessageTopToViewConstraint.priority = 1;
        }
        
    } else {
        self.continueLabel.attributedText = attributedEmpty;
        self.collapseContinueToToolsConstraint.priority = 1;
        self.collapseMessageToCreditsConstraint.priority = 999;
        self.collapseCloseButtonConstraint.priority = 1;
        
        if (!self.fbActivity.imagePath) {
            self.collapseImageAndMessageOverlapConstraint.priority = 999;
            self.collapseMessageTopToViewConstraint.priority = 999;
        }
        
        if (self.fbActivity.likes.count == 0) {
            self.collapseLikesToCommentsConstraint.priority = 999;
        }
        
        if (self.fbActivity.comments.count == 0) {
            self.collapseCommentsToToolsConstraint.priority = 999;
        }
    }
}

- (void)setImageViewDimensions:(UIImage *)targetImage trueAspectRatio:(BOOL)useTrueAspectRatio {
    float heightToWidthRatio = targetImage.size.height / targetImage.size.width;
    float imageAspectRatio = useTrueAspectRatio ? heightToWidthRatio : kMainPageAspectRatio;
    float newViewHeight = imageAspectRatio * CGRectGetWidth(self.postImageView.frame);
    self.imageHeightConstraint.constant = newViewHeight;
}

- (void)setImageWidth:(CGFloat)imageWidth trueAspectRatio:(BOOL)useTrueAspectRatio {
    CGRect frame = CGRectMake(0, 0, imageWidth, self.postImageView.bounds.size.height);
    self.postImageView.frame = frame;
    
    if (self.fbActivity.imagePath) {
        NSURL *imageURL = [NSURL URLWithString:self.fbActivity.imagePath];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *postImage = [UIImage imageWithData:imageData];
        self.collapseImageConstraint.priority = 1;
        [self setImageViewDimensions:postImage trueAspectRatio:useTrueAspectRatio];
    }
}

- (void)setPostImage:(UIImage *)image {
    self.collapseImageConstraint.priority = 1;
    [self setImageViewDimensions:image trueAspectRatio:!self.collapsed];
    [self.postImageView setImage:image];
    [self layoutIfNeeded];
}

- (void)constructFullPost:(NMAFBActivity *)fbActivity collapsed:(BOOL)collapsed {
    [self setCollapsedCellState:collapsed];
    
    NSAttributedString *messageText = fbActivity.message ?
    [[NSAttributedString alloc] initWithString:fbActivity.message] :
    [[NSAttributedString alloc] initWithString:@""];
    
    self.messageLabel.attributedText = messageText;
    self.likeCreditsLabel.attributedText = [self constructLikeCredits:fbActivity];
    self.commentThreadLabel.attributedText = [self constructCommentThread:fbActivity];
    
    NSString *likeCountText = [@(self.fbActivity.likes.count) stringValue];
    [self.likesButton setTitle:likeCountText forState:UIControlStateNormal];
    NSString *commentCountText = [@(self.fbActivity.comments.count) stringValue];
    [self.commentsButton setTitle:commentCountText forState:UIControlStateNormal];
    [self.messageLabel sizeToFit];

}

- (IBAction)viewMoreComments:(UIButton *)sender {
    NSMutableAttributedString *commentThread = [[NSMutableAttributedString alloc] initWithAttributedString:self.commentThreadLabel.attributedText];
    self.commentThreadLabel.attributedText = [self appendComments:self.fbActivity
                                                         toThread:commentThread
                                                           amount:kCommentAddRate];
    [self reloadParentTable];
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
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self.delegate presentViewController:activityController animated:YES completion:nil];
}

- (void)reloadParentTable {
    //TODO: I don't think this is the right way to do this? layoutIfNeeded doesnt work?
    UITableView *parentTable = (UITableView *)self.superview;
    if (![parentTable isKindOfClass:[UITableView class]]) {
        parentTable = (UITableView *) parentTable.superview;
    }
    
    [parentTable reloadData];
}

- (NSAttributedString *)constructLikeCredits:(NMAFBActivity *)fbActivity {
    NSMutableAttributedString *likeCreditString = [[NSMutableAttributedString alloc] initWithString:@""];
    if (fbActivity.likes.count == 0) {
        //likeCreditString stays empty on no likes
    } else if (fbActivity.likes.count == 1) {
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
        NSString *peopleOrPerson = remainingLikes > 1 ? @"people" : @"person";
        NSString *likeOrLikes = remainingLikes > 1 ? @"like" : @"likes";
        NSAttributedString *attributedAnd = [[NSAttributedString alloc] initWithString:@"and "];
        [likeCreditString appendAttributedString:attributedAnd];
        NSAttributedString *attributedRemainingLikes = [self attributedRemainingLikes:remainingLikes];
        [likeCreditString appendAttributedString:attributedRemainingLikes];
        NSString *creditEnd = [NSString stringWithFormat:@" other %@ %@ this post.", peopleOrPerson, likeOrLikes];
        NSAttributedString *attributedCreditEnd = [[NSAttributedString alloc] initWithString:creditEnd];
        [likeCreditString appendAttributedString:attributedCreditEnd];
        
    } else {
        for (NSInteger likeIndex = 0; likeIndex < fbActivity.likes.count - 1; likeIndex++ ) {
            NMAFBLike *like = fbActivity.likes[likeIndex];
            [self appendLike:like to:likeCreditString index:likeIndex limit:fbActivity.likes.count lastCommaSpacer:2];
        }
        
        NSAttributedString *attributedAnd = [[NSAttributedString alloc] initWithString:@"and "];
        [likeCreditString appendAttributedString:attributedAnd];
        NMAFBLike *finalLike = fbActivity.likes[fbActivity.likes.count - 1];
        NSAttributedString *attributedFinalLike = [self boldedString:finalLike.likerName];
        [likeCreditString appendAttributedString:attributedFinalLike];
        NSAttributedString *attributedEnd = [[NSAttributedString alloc] initWithString:@" like this post."];
        [likeCreditString appendAttributedString:attributedEnd];
    }
    
    return likeCreditString;
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

- (NSMutableAttributedString *)constructCommentThread:(NMAFBActivity *)fbActivity {
    NSMutableAttributedString *commentThreadString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSInteger currentDisplayed = self.displayedCommentCount > kCommentAddRate ? self.displayedCommentCount : kCommentAddRate;
    self.displayedCommentCount = 0;
    [self appendComments:fbActivity toThread:commentThreadString amount:currentDisplayed];
    
    return commentThreadString;
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
    self.viewMoreButton.hidden = finalComments || self.collapsed;
    
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
    NSDictionary *nameAttributes = @{ NSFontAttributeName : [UIFont NMA_proximaNovaBoldWithSize:15]};
    NSAttributedString *attributedName = [[NSAttributedString alloc] initWithString:stringToBold
                                                                         attributes:nameAttributes];
    
    return attributedName;
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
    NSDictionary *formattedRemainingLikesAttributes = @{ NSForegroundColorAttributeName : [UIColor NMA_lightGray],
                                                         NSFontAttributeName : [UIFont NMA_proximaNovaBoldWithSize:15]};
    NSAttributedString *attributedRemainingLikes = [[NSAttributedString alloc] initWithString:formattedRemainingLikes
                                                                                   attributes:formattedRemainingLikesAttributes];
    
    return attributedRemainingLikes;
}

@end
