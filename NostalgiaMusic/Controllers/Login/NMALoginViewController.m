//
//  NMALoginViewController.m
//  NostalgiaMusic
//
//  Created by Amy Ly on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NMALoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface NMALoginViewController ()

@end

@implementation NMALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // don't know how to set fbsdkloginbutton to logout--it does this automatically in storyboard...
    //self.loginButtonView = [[FBSDKLoginButton alloc] init];
    
     self.loginButtonView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
//    NSLog(@"%@", )
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"user is logged in");
    } else {
        NSLog(@"display button");
    }
    
}
- (IBAction)loginButtonPressed:(FBSDKLoginButton *)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
