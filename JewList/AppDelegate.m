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
#import "GAI.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[[Crashlytics class]]];
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    // [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    // [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelInfo];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-59561571-1"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
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
    [self setAppearance];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    return YES;
    
}

- (void)setAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x39a9ef)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initLogedOut) name:kUserLogedOutNotification object:nil];
}

- (void)initLogedOut
{
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

- (void)initLogedIn
{
    ResultsViewController *resultsVC = [[ResultsViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:resultsVC];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
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
    [FBSDKAppEvents activateApp];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
