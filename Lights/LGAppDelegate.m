//
//  LGAppDelegate.m
//  Lights
//
//  Created by Nathan Borror on 9/7/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "LGAppDelegate.h"
#import "LGViewController.h"

@implementation LGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
    NSLog(@"Laucned for location");

    UILocalNotification *notif = [[UILocalNotification alloc] init];
    [notif setAlertBody:@"Location!"];
    [notif setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    [notif setTimeZone:[NSTimeZone defaultTimeZone]];
    [[UIApplication sharedApplication] setScheduledLocalNotifications:@[notif]];

    return YES;
  }

  // Register for push
  [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

  // Set app defaults
  NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"10.0.1.3" forKey:@"ip_preference"];
  [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
  [[NSUserDefaults standardUserDefaults] synchronize];

  LGViewController *viewController = [[LGViewController alloc] init];
  [_window setRootViewController:viewController];

  [_window setBackgroundColor:[UIColor blackColor]];
  [_window makeKeyAndVisible];
  return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  UILocalNotification *notif = [[UILocalNotification alloc] init];
  [notif setAlertBody:@"Did enter background"];
  [notif setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
  [notif setTimeZone:[NSTimeZone defaultTimeZone]];
  [[UIApplication sharedApplication] setScheduledLocalNotifications:@[notif]];
}

#pragma mark - Push Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  NSLog(@"Push Token: %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
  NSLog(@"Failed to aquire push token: %@", error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
  NSLog(@"Received remote notification");
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
  NSLog(@"Received local notification");
}

@end
