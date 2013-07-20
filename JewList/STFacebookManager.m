//
//  STFacebookManager.m
//
//  Created by Oren Zitoun on 2/21/13.
//

#import "STFacebookManager.h"
#import "User.h"
#import "SHApi.h"

@implementation STFacebookManager

+ (STFacebookManager *)sharedInstance {
    static dispatch_once_t pred;
    static STFacebookManager *obj = nil;
	
    dispatch_once(&pred, ^{ obj = [[self alloc] init]; });
    return obj;
}
 
- (id)init
{
	if ((self = [super init])) {

         //Initialize Facebook
        
        self.facebook = [[Facebook alloc] initWithAppId:kFacebook_App_Id andDelegate:self];
        
        // Check and retrieve authorization information
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
            self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
         
        
	}
    return self;
    
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)cancel
{
    [_meRequest cancel];
    [self releaseCallbacks];
}

- (void)releaseCallbacks
{
	if (_success) {
        //Block_release(_success);
        _success = nil;
    }
	if (_failure) {
       // Block_release(_failure);
        _failure = nil;
    }
}

- (BOOL)isConnected
{
    BOOL isConnected = NO;

    if(self.facebook && [self.facebook.accessToken length] > 0)
    {
        isConnected = YES;
    }
    
    return isConnected;
}

- (void)logout
{
    [_facebook logout];
    _facebook.accessToken = nil;
    _facebook.expirationDate = nil;
    
    [FBSession.activeSession closeAndClearTokenInformation];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)connectWithSuccess:(void (^)(NSDictionary *dict))success
				   failure:(void (^)(NSError *error))failure
{

   	[self releaseCallbacks];

   	_success = [success copy];
	_failure = [failure copy];

    [self openSessionWithAllowLoginUI:YES];

}


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
{
    // FBSample logic
    // Any time the session is closed, we want to display the login controller (the user
    // cannot use the application unless they are logged in to Facebook). When the session
    // is opened successfully, hide the login controller and show the main UI.
    
    
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                
                // Store the Facebook session information
                _facebook.accessToken = FBSession.activeSession.accessTokenData.accessToken;
                _facebook.expirationDate = FBSession.activeSession.accessTokenData.expirationDate;
                [self storeAuthData:[_facebook accessToken] expiresAt:[_facebook expirationDate]];

                if(nil != session.accessTokenData.accessToken)
                {
                    self.fbToken = session.accessTokenData.accessToken;
                    [self populateUserDetails];
                    
                }
                // We have a valid session
                
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            
            [FBSession.activeSession closeAndClearTokenInformation];
            // Clear out the Facebook instance
            _facebook = nil;

            if([error code] == 2)
            {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:NSLocalizedString(@"cant_login", @"Cant login to Facebook")
                                              message:NSLocalizedString(@"cant_login_messaege", @"Please enable facebook login in Settings->Facebook")
                                              delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil]; //NSLocalizedString(@"menuitem_settings", @"Settings")

                    [alertView show];
                }
            }else if(error) {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Error"
                                          message:error.localizedDescription
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
            
            
            break;
        default:
            break;
    }

    [[NSNotificationCenter defaultCenter]
     postNotificationName:kFBSessionStateChangedNotification
     object:session];
    

    
}

- (void)populateUserDetails {

    if (FBSession.activeSession.isOpen)
    {
        [_meRequest cancel];
        
       self.meRequest = [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
        {
             if (!error)
             {
                 NSDictionary *response = @{@"id" : [user objectForKey:@"id"] , @"token" : _fbToken};
                 BD_LOG(@"FB response = %@",response);
                 
                 User *currentUser = [[User alloc] init];
                 currentUser.fbId = [user objectForKey:@"id"];
                 currentUser.fbToken = _fbToken;
                 currentUser.firstName = [user objectForKey:@"first_name"];
                 currentUser.lastName = [user objectForKey:@"last_name"];
                 currentUser.gendre = [user objectForKey:@"gender"];
                 currentUser.fbMeResult = user;
                 currentUser.fbImageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",currentUser.fbId];
                 
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
                 
                 [[SHApi sharedInstance] setCurrentUser:currentUser];

                 if(nil != _success)
                     _success(response);

             }else
             {
                 if(nil != _failure)
                     _failure(error);
 
             }
         }];
    }
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    NSArray *writepermissions = [[NSArray alloc] initWithObjects:
                                 @"publish_stream",
                                 @"publish_actions",
                                 @"user_location",
                                 @"user_hometown",
                                 @"email",
                                 nil];
    
    /*
    + (BOOL)openActiveSessionWithPublishPermissions:(NSArray*)publishPermissions
defaultAudience:(FBSessionDefaultAudience)defaultAudience
     */

    return [FBSession openActiveSessionWithPublishPermissions:writepermissions
                                              defaultAudience:FBSessionDefaultAudienceEveryone
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             [self sessionStateChanged:session state:state error:error];
                                         }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // FBSample logic
    // We need to handle URLs by passing them to FBSession in order for SSO authentication
    // to work.
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
    }
}

#pragma mark FBSessionDelegate
- (void)fbDidLogin
{
    [self storeAuthData:self.facebook.accessToken expiresAt:self.facebook.expirationDate];

}
- (void)fbDidNotLogin:(BOOL)cancelled
{
    
}
- (void)fbDidExtendToken:(NSString*)accessToken
                expiresAt:(NSDate*)expiresAt
{
    
    [self storeAuthData:accessToken expiresAt:expiresAt];

}
- (void)fbDidLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbSessionInvalidated
{
    
}

- (NSString *)FBErrorCodeDescription:(FBErrorCode) code {
    switch(code){
        case FBErrorInvalid :{
            return @"FBErrorInvalid";
        }
        case FBErrorOperationCancelled:{
            return @"FBErrorOperationCancelled";
        }
        case FBErrorLoginFailedOrCancelled:{
            return @"FBErrorLoginFailedOrCancelled";
        }
        case FBErrorRequestConnectionApi:{
            return @"FBErrorRequestConnectionApi";
        }case FBErrorProtocolMismatch:{
            return @"FBErrorProtocolMismatch";
        }
        case FBErrorHTTPError:{
            return @"FBErrorHTTPError";
        }
        case FBErrorNonTextMimeTypeReturned:{
            return @"FBErrorNonTextMimeTypeReturned";
        }
        
        default:
            return @"[Unknown]";
    }
}

@end
