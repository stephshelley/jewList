//
//  SHApi.h
//  JewList
//
//  Created by Oren Zitoun on 7/19/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHAccessToken.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFURLConnectionOperation.h"
#import "SHLoginPassword.h"

#define CANCEL_RELEASE_REQUEST(req) if (req) { [[SHApi sharedInstance] cancelRequest:req]; req  = nil; }

@class User;

@interface SHApi : NSObject

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSDictionary *currentUserDetails;
@property (nonatomic, strong) SHAccessToken *shAccessToken;
@property (nonatomic, strong) SHLoginPassword *shLoginPassword;


- (void)logout;
+ (id)sharedInstance;
- (void)cancelRequest:(id)request;
- (void)cacheCurrentUserDetails;

- (NSString *)apiURLForPath:(NSString *)path andQuery:(NSString *)query;
- (NSString *)apiSecureURLForPath:(NSString *)path andQuery:(NSString *)query;

- (void)enrichNSMutableURLRequestWithAuth:(NSMutableURLRequest *)request;
- (void)enrichNSMutableURLRequestWithAuthLikeGet:(NSMutableURLRequest *)request;

// Handle Login/Passwor
- (void)saveUserLogin:(NSString *)login andPassword:(NSString *)password;
- (void)cleanUserLoginAndPassword;
- (NSString *)userLogin;
- (NSString *)userPassword;

- (id)getUser:(NSString *)userId
      success:(void (^)(User *user))success
      failure:(void (^)(NSError * error))failure;

- (id)updateUser:(User *)user
         success:(void (^)(User *user))success
         failure:(void (^)(NSError * error))failure;

- (id)getSchools:(void (^)(NSArray *colleges))success
         failure:(void (^)(NSError * error))failure;

- (id)getSchoolsForSearchTerm:(NSString *)term
                      success:(void (^)(NSArray *colleges))success
                      failure:(void (^)(NSError * error))failure;

- (id)getColleges:(void (^)(NSArray *colleges))success
          failure:(void (^)(NSError * error))failure;

- (id)loginInWithEmail:(NSString *)email
           andPassword:(NSString*)password
               success:(void (^)(void))success
               failure:(void (^)(NSError * error))failure;

- (id)loginWithFBToken:(NSString *)token
                  fbId:(NSString *)fbId
               success:(void (^)(void))success
               failure:(void (^)(NSError * error))failure;

@end
