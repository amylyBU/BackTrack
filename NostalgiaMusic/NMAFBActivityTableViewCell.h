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

@optional
- (void)closeModalDialog;

@end

@interface NMAFBActivityTableViewCell : UITableViewCell

@property (nonatomic) BOOL collapsed;
@property (strong, nonatomic) NMAFBActivity *fbActivity;
@property (strong, nonatomic) UIViewController<NMAFBActivityCellDelegate> *delegate;

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

- (void)configureCell:(BOOL)collapsed withShadow:(BOOL)shadow;
- (void)setCollapsedCellState:(BOOL)isCollapsed;

@end
