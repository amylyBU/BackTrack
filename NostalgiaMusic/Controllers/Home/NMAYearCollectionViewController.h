//
//  NMAYearCollectionViewController.h
//  NostalgiaMusic
//
//  Created by Sara Lieto on 6/25/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NMAYearCollectionViewControllerDelegate <NSObject>

-(void)didSelectYear:(NSString *)year;

@end

@interface NMAYearCollectionViewController : UICollectionViewController
@property (strong, nonatomic) UICollectionViewFlowLayout *flow;
//@property (strong, nonatomic) NSString *currentYear;
@property (weak, nonatomic) id<NMAYearCollectionViewControllerDelegate> delegate;
@end
