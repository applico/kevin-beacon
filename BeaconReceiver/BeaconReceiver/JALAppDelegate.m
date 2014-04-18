//
//  JALAppDelegate.m
//  BeaconReceiver
//
//  Created by Josh Lieberman on 4/4/14.
//  Copyright (c) 2014 Josh Lieberman. All rights reserved.
//

#import "JALAppDelegate.h"
#import <KinveyKit/KinveyKit.h>

@implementation JALAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    // Kinvey
    (void) [[KCSClient sharedClient] initializeKinveyServiceForAppKey:@"Kinvey App Key"
                                                        withAppSecret:@"Kinvey App Secret"
                                                         usingOptions:nil];

    // Debug
    [KCSPing pingKinveyWithBlock:^(KCSPingResult *result) {
        if (result.pingWasSuccessful == YES){
            NSLog(@"Kinvey Ping Success");
        } else {
            NSLog(@"Kinvey Ping Failed");
        }
    }];

    // Login
    [KCSUser loginWithUsername:@"username" password:@"password" withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
        if (errorOrNil ==  nil) {
            //the log-in was successful and the user is now the active user and credentials saved
            //hide log-in view and show main app content
        } else {        //there was an error with the update save
            NSString* message = [errorOrNil localizedDescription];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Create account failed", @"Sign account failed")
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }];

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
