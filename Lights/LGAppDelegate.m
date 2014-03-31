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

  NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"10.0.1.3" forKey:@"ip_preference"];
  [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
  [[NSUserDefaults standardUserDefaults] synchronize];

  LGViewController *viewController = [[LGViewController alloc] init];
  [_window setRootViewController:viewController];

  [_window setBackgroundColor:[UIColor blackColor]];
  [_window makeKeyAndVisible];
  return YES;
}

@end
