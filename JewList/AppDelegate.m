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

    User *currentUser = [[SHApi sharedInstance] currentUser];
    if(!currentUser && currentUser.didFinishSignup)
    {
        [self initLogedIn];
    }
    else
    {
        [self initLogedOut];
        
    }
    
    self.window.tintColor = UIColorFromRGB(0x54add5);
    if(IS_IOS7) [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    
    if (!IsIpad && [[UINavigationBar class] respondsToSelector:@selector(appearance)])
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar_bkg"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIColor whiteColor],
          UITextAttributeTextColor,
          [UIFont fontWithName:DEFAULT_FONT size:20.0],
          UITextAttributeFont,
          nil]];
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

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
