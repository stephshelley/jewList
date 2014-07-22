//
//  STFacebookManager.h
//
//  Created by Oren Zitoun on 2/21/13.
//

#import <FacebookSDK/FacebookSDK.h>

@class User;

@interface STFacebookManager : NSObject <UIAlertViewDelegate>

+ (STFacebookManager *)sharedInstance;

@property (copy) void (^success)(NSDictionary *dict, User *user);
@property (copy) void (^failure)(NSError *error);

@property (nonatomic, strong) NSString *fbToken;

//@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) FBRequestConnection *meRequest;



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
