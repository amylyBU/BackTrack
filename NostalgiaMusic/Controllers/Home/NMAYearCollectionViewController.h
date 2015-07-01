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

-(void)didSelectYear:(NSString *)year;

@end

@interface NMAYearCollectionViewController : UICollectionViewController
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) id <NMAYearCollectionViewControllerDelegate> delegate;

- (void)moveToYear:(NSString *)year;
@end
