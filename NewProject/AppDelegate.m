//
//  AppDelegate.m
//  NewProject
//
//  Created by mac on 14-7-30.
//  Copyright (c) 2014年 于建祥. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LockViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    ViewController * rt = [[ViewController alloc]init];
    self.window.rootViewController =rt;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    LockViewController *lock = [LockViewController new];
    [self.window.rootViewController presentViewController:lock animated:YES completion:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    LockViewController *lock = [LockViewController new];
    
    if (self.window.rootViewController.presentedViewController)
    {
        if (![[[self.window.rootViewController.presentedViewController class] description] isEqualToString:@"LockViewController"])
        {
            [self.window.rootViewController.presentedViewController presentViewController:lock animated:NO completion:Nil];
        }
    }
    else
    {
        if (![[[self.window.rootViewController class] description] isEqualToString:@"LockViewController"])
        {
            [self.window.rootViewController presentViewController:lock animated:NO completion:Nil];
        }
    }
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end