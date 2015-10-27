//
//  STFacebookManager.h
//
//  Created by Oren Zitoun on 2/21/13.
//


@class User;

@interface STFacebookManager : NSObject <UIAlertViewDelegate>

+ (STFacebookManager *)sharedInstance;

@property (copy) void (^success)(NSDictionary *dict, User *user);
@property (copy) void (^failure)(NSError *error);

@property (nonatomic, strong) NSString *fbToken;

@property (nonatomic, strong) FBSDKAccessToken *facebookToken;
//@property (nonatomic, strong) FBRequestConnection *meRequest;

- (void)setFacebookToken:(FBSDKAccessToken *)facebookToken
              completion:(void (^)(NSDictionary *result))completionBlock;

- (BOOL)isConnected;
- (void)logout;
- (void)cancel;

- (void)connectWithSuccess:(void (^)(NSDictionary *dict, User *user))success
				   failure:(void (^)(NSError *error))failure;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;


@end
