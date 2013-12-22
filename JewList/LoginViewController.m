//
//  LoginViewController.m
//  JewList
//
//  Created by Oren Zitoun on 7/19/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "LoginViewController.h"
#import "SHApi.h"
#import "User.h"
#import "STFacebookManager.h"
#import "SHProfileViewController.h"
#import "ResultsViewController.h"

@implementation LoginViewController


- (void)loadView
{
    [super loadView];

    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.navigationController.navigationBarHidden = YES;
    
    self.loginView = [[SHLoginOnboardingView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-20)];
    [_loginView.fbConnectButton addTarget:self action:@selector(fbConnectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginView];
    
    self.title = @"Shalom!";
    
}

- (void)fbConnectButtonPressed
{
    [[STFacebookManager sharedInstance] connectWithSuccess:^(NSDictionary *response)
     {
         if([response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"id"] && [response objectForKey:@"token"])
         {
             [self processLoginResponse:[response objectForKey:@"id"] withToken:[response objectForKey:@"token"]];
         }
     } failure:^(NSError *error)
     {
         BD_LOG(@"Facebook login Failed | error = %@",[error userInfo]);
     }];
}

- (void)processLoginResponse:(NSString *)uid withToken:(NSString *)token
{
    CANCEL_RELEASE_REQUEST(self.connectToSocialProviderRequest);
    [self continueToStep1];

}

- (SHOnboarding1View*)onboardingStep1
{
    self.title = @"Welcome";
    
    if(nil == _onboardingStep1)
    {
        User *currentUser = [[SHApi sharedInstance] currentUser];
        _onboardingStep1 = [[SHOnboarding1View alloc] initWithFrame:CGRectMake(0, _loginView.top, _loginView.width, _loginView.height - 20) andUser:currentUser];
        [_onboardingStep1.nextStepButton addTarget:self action:@selector(continueToStep2) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_onboardingStep1];
        
    }
    
    return _onboardingStep1;
    
}

- (SHOnboarding2View*)onboardingStep2
{
    if(nil == _onboardingStep2)
    {
        User *currentUser = [[SHApi sharedInstance] currentUser];
        _onboardingStep2 = [[SHOnboarding2View alloc] initWithFrame:CGRectMake(0, _loginView.top, _loginView.width, _loginView.height - 20) andUser:currentUser];
        _onboardingStep2.delegate = self;
        [_onboardingStep2.nextStepButton addTarget:self action:@selector(continueToStep3) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_onboardingStep2];
    }
    
    return _onboardingStep2;
}

- (SHOnboarding3View*)onboardingStep3
{
    self.title = @"Results";

    if(nil == _onboardingStep3)
    {
        User *currentUser = [[SHApi sharedInstance] currentUser];
        _onboardingStep3 = [[SHOnboarding3View alloc] initWithFrame:CGRectMake(0, _loginView.top, _loginView.width, _loginView.height - 20) andUser:currentUser];
        [_onboardingStep3.nextStepButton addTarget:self action:@selector(continueToStep4) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_onboardingStep3];
        
    }
    
    return _onboardingStep3;
    
}


- (STOnboarding4View*)onboardingStep4
{
    self.title = @"Graduation year";
    
    if(nil == _onboardingStep4)
    {
        User *currentUser = [[SHApi sharedInstance] currentUser];
        _onboardingStep4 = [[STOnboarding4View alloc] initWithFrame:CGRectMake(0, _loginView.top, _loginView.width, _loginView.height - 20) andUser:currentUser];
        _onboardingStep4.delegate = self;
        [_onboardingStep4.nextStepButton addTarget:self action:@selector(continueToStep4) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_onboardingStep4];
        
    }
    
    return _onboardingStep4;
    
}
- (void)continueToStep1
{
    /*
    User *currentUser = [[SHApi sharedInstance] currentUser];
    currentUser.shabat = @"Meh";
    currentUser.kosher = @"Yep";
    SHProfileViewController *userVC = [[SHProfileViewController alloc] initWithUser:currentUser];
    [self.navigationController pushViewController:userVC animated:YES];
    
    return ;
*/
    
    [self animateToNextStep:_loginView destination:self.onboardingStep1];
}

- (void)continueToStep2
{
    [self animateToNextStep:self.onboardingStep1 destination:self.onboardingStep2];
    [_onboardingStep2.searchBar becomeFirstResponder];

    
}

- (void)continueToStep3
{
    [self animateToNextStep:self.onboardingStep2 destination:self.onboardingStep4];
    [_onboardingStep2.searchBar resignFirstResponder];
}

- (void)continueToStep4
{
    //[self animateToNextStep:self.onboardingStep4 destination:self.onboardingStep3];

    // perform put for user profile
    
    [_onboardingStep4 showLoading];
    __weak __block STOnboarding4View *blockView4 = _onboardingStep4;
    __weak __block LoginViewController *weakSelf = self;
    
    [[SHApi sharedInstance] updateUser:_onboardingStep4.user success:^(User *user)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [blockView4 hideLoading];
             //[weakSelf animateToNextStep:self.onboardingStep4 destination:self.onboardingStep3];
             [weakSelf showResultsScreen];

         });

         
     }failure:^(NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [blockView4 hideLoading];
             [weakSelf showResultsScreen];
            // [weakSelf animateToNextStep:self.onboardingStep4 destination:self.onboardingStep3];
         });
         

     }];
    
}

- (void)showResultsScreen
{
    ResultsViewController *vc = [[ResultsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    
}

- (void)animateToNextStep:(UIView*)originView destination:(UIView*)destinationView
{
    destinationView.left = self.view.width;
    //__block UIView *_originView = originView;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         destinationView.left = 0;
                         originView.left = -self.view.width;
                         
                     }
                     completion:^(BOOL finished){
                         
                     }
     ];
}

- (void)animateBacktStep:(UIView*)originView destination:(UIView*)destinationView
{
    destinationView.right = 0;
    __block UIView *_originView = originView;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         destinationView.left = 0;
                         originView.left = self.view.width;
                         
                     }
                     completion:^(BOOL finished){
                         
                     }
     ];
}

#pragma mark - SHOnboardingDelegate -
- (void)continueToNextStep:(id)sender
{
    if(sender == _onboardingStep2)
    {
        [self continueToStep3];
        
    }
}

- (void)goToPreviousStep:(id)sender
{
    if(sender == _onboardingStep2)
    {
        [self animateBacktStep:self.onboardingStep2 destination:self.onboardingStep1];
        
    }
    else if(sender == _onboardingStep4)
    {
        [self animateBacktStep:self.onboardingStep4 destination:self.onboardingStep2];
        
    }
    
}

@end
