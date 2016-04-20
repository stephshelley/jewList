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
#import "UserResultsViewController.h"
#import "AppDelegate.h"
#import "WelcomeViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController() <FBSDKLoginButtonDelegate> {
    __weak IBOutlet UIImageView *logoImageView;
    __weak IBOutlet FBSDKLoginButton *fbLoginButton;
    BOOL _didBeginToLogin;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Login";
}

- (void)initializeOnboarding {
    WelcomeViewController *welcomeVC = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    welcomeVC.user = [[SHApi sharedInstance] currentUser];
    [self.navigationController pushViewController:welcomeVC animated:YES];
}

- (void)finishOnboarding {
    __weak __block LoginViewController *weakSelf = self;
    
    User *user = [[SHApi sharedInstance] currentUser];
    user.fbToken = [[STFacebookManager sharedInstance] fbToken];
    user.didFinishSignup = YES;
    [[SHApi sharedInstance] setCurrentUser:user];
    
    [[SHApi sharedInstance] updateUser:user success:^(User *user)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf showResultsScreen];
         });
     }failure:^(NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf showResultsScreen];
             
         });
     }];
}

- (void)showResultsScreen {
    UserResultsViewController *vc = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"UserResultsViewController"];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark FBLoginViewDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error
{
    self.loadingView.hidden = NO;
    [self.loadingIndicatorView startAnimating];
    fbLoginButton.hidden = YES;
    NSString *accessToken = result.token.tokenString;
    [[STFacebookManager sharedInstance] setFacebookToken:result.token completion:^(NSDictionary *fbUser) {
         NSDictionary *response = @{@"id" : [fbUser objectForKey:@"id"] , @"token" : accessToken};
         BD_LOG(@"FB response = %@",response);
         
         
         if(_didBeginToLogin) return;
         
         if([response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"id"] && [response objectForKey:@"token"]) {
             NSString *token = accessToken;
             NSString *fbId = [response objectForKey:@"id"];
             
             _didBeginToLogin = YES;
             
             [[SHApi sharedInstance] loginWithFBToken:token fbId:fbId success:^(void)
              {
                  User *currentUser = [[SHApi sharedInstance] currentUser];
                  
                  currentUser.fbId = [fbUser objectForKey:@"id"];
                  currentUser.fbToken = accessToken;
                  currentUser.fbMeResult = (NSDictionary *)fbUser;
                  currentUser.fbUsername = [fbUser objectForKey:@"username"];
                  
                  if([fbUser objectForKey:@"hometown"] && [[fbUser objectForKey:@"hometown"] objectForKey:@"id"]) {
                      currentUser.fbHometownId = SAFE_VAL([[fbUser objectForKey:@"hometown"] objectForKey:@"id"]);
                      currentUser.fbHometownName = SAFE_VAL([[fbUser objectForKey:@"hometown"] objectForKey:@"name"]);
                  }
                  
                  if([fbUser objectForKey:@"location"] && [[fbUser objectForKey:@"location"] objectForKey:@"id"]) {
                      currentUser.fbLocationId = SAFE_VAL([[fbUser objectForKey:@"location"] objectForKey:@"id"]);
                      currentUser.fbLocationName = SAFE_VAL([[fbUser objectForKey:@"location"] objectForKey:@"name"]);
                  }
                  
                  if([fbUser objectForKey:@"education"]) {
                      NSArray *schools = [fbUser objectForKey:@"education"];
                      int lastYear = 0;
                      for(NSDictionary *school in schools) {
                          if([school objectForKey:@"type"] &&
                             ([[school objectForKey:@"type"] isEqualToString:@"Graduate School"] || [[school objectForKey:@"type"] isEqualToString:@"College"])) {
                              if([school objectForKey:@"year"]) {
                                  int currentYear = [[[school objectForKey:@"year"] objectForKey:@"name"] intValue];
                                  if(currentYear > lastYear) {
                                      lastYear = currentYear;
                                      if([[school objectForKey:@"school"] objectForKey:@"name"]) {
                                          currentUser.fbCollegeName = [[school objectForKey:@"school"] objectForKey:@"name"];
                                          
                                      }
                                  }
                              }
                          }
                          
                      }
                  }
                  
                  currentUser.fb = [fbId copy];
                  if(!currentUser.firstName) {
                      currentUser.firstName = [fbUser objectForKey:@"first_name"];
                  }
                  
                  if(!currentUser.lastName) {
                      currentUser.lastName = [fbUser objectForKey:@"last_name"];
                  }
                  
                  if(!currentUser.gender)  {
                      currentUser.gender = [[fbUser objectForKey:@"gender"] stringValue];
                  }
                  
                  if(currentUser.email.length == 0) {
                      currentUser.email = [fbUser objectForKey:@"email"];
                  }
                  
                  if(!currentUser.fbImageUrl) {
                      currentUser.fbImageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",currentUser.fbId];
                  }
                  
                  [[SHApi sharedInstance] setCurrentUser:currentUser];
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      _didBeginToLogin = NO;
                      if (currentUser.didFinishSignup) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                             [self showResultsScreen];
                              self.loadingView.hidden = YES;
                              [self.loadingIndicatorView stopAnimating];
                          });
                      } else {
                          [self initializeOnboarding];
                          self.loadingView.hidden = YES;
                          [self.loadingIndicatorView stopAnimating];
                      }
                  });
              }failure:^(NSError *error)
              {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      self.loadingView.hidden = YES;
                      [self.loadingIndicatorView stopAnimating];
                      fbLoginButton.hidden = NO;

                      [SHUIHelpers alertErrorWithMessage:@"An error occurred"];
                      _didBeginToLogin = NO;
                  });
              }];
         }
     }];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

@end
