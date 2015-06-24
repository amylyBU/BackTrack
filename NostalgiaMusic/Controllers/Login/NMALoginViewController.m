//
//  NMALoginViewController.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMALoginViewController.h"

@interface NMALoginViewController ()
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property (strong, nonatomic) NMAFacebookManager *FBManager;

@end

@implementation NMALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.descriptionTextField.editable = NO;
    
    self.FBManager = [[NMAFacebookManager alloc] init];

    
    self.loginButtonView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    NSLog(@"permissions are: %@", self.loginButtonView.readPermissions);
    //NSLog(@"the user is: %@", )
}


@end
