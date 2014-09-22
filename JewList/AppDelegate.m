//
//  AppDelegate.m
//  JewList
//
//  Created by Oren Zitoun on 7/19/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "AppDelegate.h"
#import "SHApi.h"
#import "LoginViewController.h"
#import "ResultsViewController.h"
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"31dfbac86c4d492f43c608f6b495f594a67cee2e"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self registerNotifications];
    
    User *currentUser = [[SHApi sharedInstance] currentUser];
    if(currentUser != nil)
    {
        [self initLogedIn];
    }
    else
    {
        [self initLogedOut];
        
    }
    
    self.window.tintColor = UIColorFromRGB(0x54add5);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    
    if (!IsIpad && [[UINavigationBar class] respondsToSelector:@selector(appearance)])
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar_bkg"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIColor whiteColor],
          UITextAttributeTextColor,
          [UIFont fontWithName:DEFAULT_FONT_BOLD size:16.0],
          UITextAttributeFont,
          nil]];
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

	}
    
    [self.window makeKeyAndVisible];
    return YES;
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initLogedOut) name:kUserLogedOutNotification object:nil];
}

- (void)initLogedOut
{
    if(IS_IOS7) [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = navController;

}

- (void)initLogedIn
{
    if(IS_IOS7) [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    ResultsViewController *resultsVC = [[ResultsViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:resultsVC];
    self.window.rootViewController = navController;

}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshResultsScreenNotification object:nil userInfo:nil];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
