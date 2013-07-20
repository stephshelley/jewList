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

@implementation LoginViewController


- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.loginView = [[SHLoginOnboardingView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height-20)];
    [_loginView.fbConnectButton addTarget:self action:@selector(fbConnectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _loginView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_loginView];
}

- (void)fbConnectButtonPressed
{
    [[STFacebookManager sharedInstance] connectWithSuccess:^(NSDictionary *response)
     {
         if([response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"id"] && [response objectForKey:@"token"])
         {
             
             [self processLoginResponse:[response objectForKey:@"id"] withToken:[response objectForKey:@"token"]];
         }
     }failure:^(NSError *error)
     {
         BD_LOG(@"Facebook login Failed | error = %@",[error userInfo]);
     }];
}

- (void)processLoginResponse:(NSString *)uid withToken:(NSString *)token
{
    __unsafe_unretained __block LoginViewController *weakSelf = (LoginViewController *)self;
    
    CANCEL_RELEASE_REQUEST(self.connectToSocialProviderRequest);
    [self continueToStep1];
    /*
     self.connectToSocialProviderRequest = [[SHApi sharedInstance] connectToSocialProvider:@"facebook" uid:uid token:token expiresIn:@"" success:^(void)
     {
     dispatch_async(dispatch_get_main_queue(), ^{
     weakSelf.loginView.hidden = YES;
     [weakSelf loadTable];
     [weakSelf loadFBFriends];
     });
     
     STORM_LOG(@"connectToSocialProvider success");
     }failure:^(NSError *error)
     {
     STORM_LOG(@"connectToSocialProvider login Failed | error = %@",[error userInfo]);
     
     }];
     */
    
}

- (SHOnboarding1View*)onboardingStep1
{
    if(nil == _onboardingStep1)
    {
        User *currentUser = [[SHApi sharedInstance] currentUser];
        _onboardingStep1 = [[SHOnboarding1View alloc] initWithFrame:CGRectMake(0, _loginView.top, _loginView.width, _loginView.height - 40) andUser:currentUser];
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
        _onboardingStep2 = [[SHOnboarding2View alloc] initWithFrame:CGRectMake(0, _loginView.top, _loginView.width, _loginView.height - 40) andUser:currentUser];
        [_onboardingStep2.nextStepButton addTarget:self action:@selector(continueToStep3) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_onboardingStep2];
        
    }
    
    return _onboardingStep2;
    
}

- (SHOnboarding3View*)onboardingStep3
{
    if(nil == _onboardingStep3)
    {
        User *currentUser = [[SHApi sharedInstance] currentUser];
        _onboardingStep3 = [[SHOnboarding3View alloc] initWithFrame:CGRectMake(0, _loginView.top, _loginView.width, _loginView.height - 40) andUser:currentUser];
        [_onboardingStep3.nextStepButton addTarget:self action:@selector(continueToStep4) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_onboardingStep3];
        
    }
    
    return _onboardingStep3;
    
}

- (void)continueToStep1
{
    [self animateToNextStep:_loginView destination:self.onboardingStep1];
    
}

- (void)continueToStep2
{
    [self animateToNextStep:self.onboardingStep1 destination:self.onboardingStep2];
    
}

- (void)continueToStep3
{
    [self animateToNextStep:self.onboardingStep2 destination:self.onboardingStep3];
    
}

- (void)continueToStep4
{
    
}

- (void)animateToNextStep:(UIView*)originView destination:(UIView*)destinationView
{
    destinationView.left = self.view.width;
    __block UIView *_originView = originView;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         destinationView.left = 0;
                         originView.left = -self.view.width;
                         
                     }
                     completion:^(BOOL finished){
                         [_originView removeFromSuperview];
                         _originView = nil;
                         
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
                         [_originView removeFromSuperview];
                         _originView = nil;
                         
                     }
     ];
}

@end
