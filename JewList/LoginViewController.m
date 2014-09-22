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
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController() <FBLoginViewDelegate>
{
    BOOL _didBeginToLogin;
    
}
@end

@implementation LoginViewController


- (void)loadView
{
    [super loadView];

    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.navigationController.navigationBarHidden = YES;
    
    self.loginView = [[SHLoginOnboardingView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _loginView.loginView.delegate = self;
    //[_loginView.fbConnectButton addTarget:self action:@selector(fbConnectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginView];
    
    self.title = @"Shalom!";
    
}

- (void)fbConnectButtonPressed
{
    //[self continueToStep1];
    //return;
    
    [[STFacebookManager sharedInstance] connectWithSuccess:^(NSDictionary *response, User *user)
     {
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
        _onboardingStep1 = [[SHOnboarding1View alloc] initWithFrame:CGRectMake(0, _loginView.top, _loginView.width, _loginView.height) andUser:currentUser];
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
        _onboardingStep2 = [[SHOnboarding2View alloc] initWithFrame:CGRectMake(0, _loginView.top, _loginView.width, _loginView.height + (IS_IOS7 ? 20 : 0)) andUser:currentUser];
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
        _onboardingStep3 = [[SHOnboarding3View alloc] initWithFrame:CGRectMake(0, _loginView.top, _loginView.width, _loginView.height) andUser:currentUser];
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
        _onboardingStep4 = [[STOnboarding4View alloc] initWithFrame:CGRectMake(0, _loginView.top, _loginView.width, _loginView.height) andUser:currentUser];
        _onboardingStep4.delegate = self;
        [_onboardingStep4.nextStepButton addTarget:self action:@selector(continueToStep4) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_onboardingStep4];
        
    }
    
    return _onboardingStep4;
    
}

- (STOnboarding5View*)onboardingStep5
{
    self.title = @"Age";
    
    if(nil == _onboardingStep5)
    {
        User *currentUser = [[SHApi sharedInstance] currentUser];
        _onboardingStep5 = [[STOnboarding5View alloc] initWithFrame:CGRectMake(0, _loginView.top, _loginView.width, _loginView.height) andUser:currentUser];
        _onboardingStep5.delegate = self;
        [_onboardingStep5.nextStepButton addTarget:self action:@selector(continueToStep5) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_onboardingStep5];
        
    }
    
    return _onboardingStep5;
    
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
    if(_onboardingStep1.nameTextField.text.length == 0)
    {
        [SHUIHelpers alertErrorWithMessage:@"Please enter a name"];
        return;
    }
    
    if(_onboardingStep1.emailTextField.text.length == 0)
    {
        [SHUIHelpers alertErrorWithMessage:@"Please enter an email address"];
        return;
    }
    
    User *currentUser = [[SHApi sharedInstance] currentUser];
    
    NSArray *nameArray = [_onboardingStep1.nameTextField.text componentsSeparatedByString:@" "];
    if(nameArray.count > 0)
    {
        currentUser.firstName = [nameArray firstObject];
    }
    
    if(nameArray.count > 1)
    {
        currentUser.lastName = [[nameArray subarrayWithRange:NSMakeRange(1, nameArray.count - 1)] componentsJoinedByString:@" "];
    }
    
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
    [self animateToNextStep:self.onboardingStep4 destination:self.onboardingStep5];
    
}

- (void)continueToStep5
{
    [_onboardingStep5 showLoading];
    __weak __block STOnboarding5View *blockView5 = _onboardingStep5;
    __weak __block LoginViewController *weakSelf = self;
    
    User *user = _onboardingStep5.user;
    user.fbToken = [[STFacebookManager sharedInstance] fbToken];
    user.didFinishSignup = YES;
    [[SHApi sharedInstance] setCurrentUser:user];
    User *currentUser = [[SHApi sharedInstance] currentUser];
    
    [[SHApi sharedInstance] updateUser:currentUser success:^(User *user)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [blockView5 hideLoading];
             [weakSelf showResultsScreen];

         });

         
     }failure:^(NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [blockView5 hideLoading];
             [weakSelf showResultsScreen];

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
    //__block UIView *_originView = originView;
    
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
        if(IS_IOS7) [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [self animateBacktStep:self.onboardingStep2 destination:self.onboardingStep1];
        
    }
    else if(sender == _onboardingStep4)
    {
        [self animateBacktStep:self.onboardingStep4 destination:self.onboardingStep2];
        
    }else if(sender == _onboardingStep5)
    {
        [self animateBacktStep:self.onboardingStep5 destination:self.onboardingStep4];
        
    }
    
}

#pragma mark FBLoginViewDelegate
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    //[[SHApi sharedInstance] logout];
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    NSString * accessToken = [[[FBSession activeSession] accessTokenData] accessToken];

    User *currentUser = [[User alloc] init];
    currentUser.fbId = [user objectForKey:@"id"];
    currentUser.fbToken = accessToken;
    currentUser.firstName = [user objectForKey:@"first_name"];
    currentUser.lastName = [user objectForKey:@"last_name"];
    currentUser.gender = [user objectForKey:@"gender"];
    currentUser.email = [user objectForKey:@"email"];
    currentUser.fbMeResult = (NSDictionary *)user;
    currentUser.fbUsername = [user objectForKey:@"username"];
    currentUser.fbImageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",currentUser.fbId];
    
    NSDictionary *response = @{@"id" : [user objectForKey:@"id"] , @"token" : accessToken};
    BD_LOG(@"FB response = %@",response);
    
    if([user objectForKey:@"hometown"] && [[user objectForKey:@"hometown"] objectForKey:@"id"])
    {
        currentUser.fbHometownId = SAFE_VAL([[user objectForKey:@"hometown"] objectForKey:@"id"]);
        currentUser.fbHometownName = SAFE_VAL([[user objectForKey:@"hometown"] objectForKey:@"name"]);
        
    }
    
    if([user objectForKey:@"location"] && [[user objectForKey:@"location"] objectForKey:@"id"])
    {
        currentUser.fbLocationId = SAFE_VAL([[user objectForKey:@"location"] objectForKey:@"id"]);
        currentUser.fbLocationName = SAFE_VAL([[user objectForKey:@"location"] objectForKey:@"name"]);
        
    }
    
    if([user objectForKey:@"education"])
    {
        NSArray *schools = [user objectForKey:@"education"];
        
        int lastYear = 0;
        
        for(NSDictionary *school in schools)
        {
            if([school objectForKey:@"type"] &&
               ([[school objectForKey:@"type"] isEqualToString:@"Graduate School"] || [[school objectForKey:@"type"] isEqualToString:@"College"]))
            {
                if([school objectForKey:@"year"])
                {
                    int currentYear = [[[school objectForKey:@"year"] objectForKey:@"name"] intValue];
                    if(currentYear > lastYear)
                    {
                        lastYear = currentYear;
                        if([[school objectForKey:@"school"] objectForKey:@"name"])
                        {
                            currentUser.fbCollegeName = [[school objectForKey:@"school"] objectForKey:@"name"];
                            
                        }
                    }
                }
            }
            
        }
    }
    
    //[[SHApi sharedInstance] setCurrentUser:currentUser];

    if(_didBeginToLogin) return;
    
    
    if([response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"id"] && [response objectForKey:@"token"])
    {
        NSString *token = [response objectForKey:@"token"];
        NSString *fbId = [response objectForKey:@"id"];

        _didBeginToLogin = YES;

        [[SHApi sharedInstance] loginWithFBToken:token fbId:fbId success:^(void)
         {
             User *user = [[SHApi sharedInstance] currentUser];
             
             user.fb = [fbId copy];
             if(user.firstName == nil)
             {
                 user.firstName = currentUser.firstName;
             }
             
             if(user.lastName == nil)
             {
                 user.lastName = currentUser.lastName;
             }
             
             if(user.gender == nil)
             {
                 user.gender = currentUser.gender;
             }
             
             if(user.email == nil || user.email.length == 0)
             {
                 user.email = currentUser.email;
             }
             
             if(user.fbImageUrl == nil)
             {
                 user.fbImageUrl = currentUser.fbImageUrl;
             }
             
             
             [[SHApi sharedInstance] setCurrentUser:user];
             
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self continueToStep1];
                 _didBeginToLogin = NO;

                 
             });
             
             
         }failure:^(NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SHUIHelpers alertErrorWithMessage:@"An error occurred"];
                 _didBeginToLogin = NO;

             });
         }];
        
        
        
    }
    
}

@end
