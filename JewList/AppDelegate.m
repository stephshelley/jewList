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

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if(![[SHApi sharedInstance] currentUser])
    {
        [self initLogedOut];
    }
    else
    {
        [self initLogedIn];
        
    }
    
    if(IS_IOS7) [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    if (!IsIpad && [[UINavigationBar class] respondsToSelector:@selector(appearance)])
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar_bkg"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIColor whiteColor],
          UITextAttributeTextColor,
          UIColorFromRGB(0x44809c),
          UITextAttributeTextShadowColor,
          [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
          UITextAttributeTextShadowOffset,
          [UIFont fontWithName:DEFAULT_FONT size:20.0],
          UITextAttributeFont,
          nil]];
        
        [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0x83d4fa)];

	}
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initLogedOut
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = navController;

}

- (void)initLogedIn
{
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
