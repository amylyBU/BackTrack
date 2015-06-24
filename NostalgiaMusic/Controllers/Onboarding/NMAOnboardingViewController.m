//
//  NMAOnboardingViewController.m
//  NostalgiaMusic
//
//  Created by Eric Peterson on 6/23/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "AppDelegate.h"
#import "NMAOnboardingViewController.h"
#import "NMAHomeViewController.h"
#import "NMAAppSettings.h"

@interface NMAOnboardingViewController ()

@end

@implementation NMAOnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(self.hideSkip)
    {
        [self.skipButton setEnabled:NO];
        self.skipButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)completeOnboarding:(UIButton *)sender {
    //TODO: Load actual VC here
    /*
    NMAHomeViewController *homeVC = [NMAHomeViewController new];
    [self.navigationController pushViewController:homeVC animated:YES];
     */
    [[NMAAppSettings sharedSettings] setUserBool:Onboard value:YES];
}

- (IBAction)skipOnboarding:(UIButton *)sender {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //app.onboardingComplete = ?;
    [app goToHome];
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
