//
//  NMAYearCollectionViewController.h
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/25/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMAYearActivityScrollDelegate.h"

@protocol NMAYearCollectionViewControllerDelegate <NSObject>

- (void)didSelectYear:(NSString *)year;
- (void)blackoutActivity;
- (void)removeBlackoutFromScrollBar;

@end


@interface NMAYearCollectionViewController : UIViewController

@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) id <NMAYearCollectionViewControllerDelegate> delegate;
@property (copy, nonatomic) NSString *year;
@property (weak, nonatomic) IBOutlet UICollectionView *scrollBarCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *navbarIllustration;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *blackoutNavBarView;

- (void)moveToYear:(NSString *)year;

@end
