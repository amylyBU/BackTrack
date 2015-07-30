//
//  NMAFBActivityTableViewCell.h
//  NostalgiaMusic
//
//  Created by Eric Peterson on 7/7/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMAFBActivity.h"

//Delegate protocol
@protocol NMAFBActivityCellDelegate

@required
- (void)shareItems:(NSMutableArray *)itemsToShare;

@optional
- (void)closeModalDialog;
- (void)loadMoreComments:(NSInteger)addRate currentCount:(NSInteger)currentCount;

@end

@interface NMAFBActivityTableViewCell : UITableViewCell

@property (nonatomic) BOOL isCollapsed;
@property (strong, nonatomic) id<NMAFBActivityCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIView *postContainerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *continueLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCreditsLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentThreadLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewMoreButton;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIImageView *timeRibbonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collapseImageConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collapseContinueToToolsConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collapseMessageToCreditsConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collapseCloseButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collapseMessageTopToViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collapseImageAndMessageOverlapConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collapseCommentsToToolsConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collapseLikesToCommentsConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collapseViewMoreHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfOverlapConstraint;

- (void)configureCellWithActivity:(NMAFBActivity *)fbActivity collapsed:(BOOL)collapsed withShadow:(BOOL)shadow;
- (void)setCollapsedCellState:(BOOL)isCollapsed withActivity:(NMAFBActivity *)fbActivity;
- (void)setImageWidth:(CGFloat)imageWidth trueAspectRatio:(BOOL)useTrueAspectRatio withActivity:(NMAFBActivity *)fbActivity;
- (void)updateCommentThread:(NMAFBActivity *)fbActivity;

@end
