//
//  LCAppDelegate.m
//  LegendsCard
//
//  Created by Josh Sklar on 8/21/13.
//  Copyright (c) 2013 LegendsCard. All rights reserved.
//

#import "LCAppDelegate.h"
#import "LCViewController.h"

#import "User.h"

@implementation LCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"Fds8dXJZcUSdBSzksBzEEDzBK3nsCHZDVxvoyaeI"
                  clientKey:@"m6QHj2D9nn7JIuATsk28BKr2K66wFDHtU0SDf4Lk"];
    [Flurry startSession:@"DKZZ47WH5H6JM79Z4SYC"];
    [Flurry logEvent:@"user-opened-app"];
    
    // create a user object and set it's school to whatever is stored in NSUserDefaults
    [[User sharedInstance] setSchool:@"umich"];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[LCViewController alloc] init];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
