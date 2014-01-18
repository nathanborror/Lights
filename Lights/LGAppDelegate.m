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

  LGViewController *viewController = [[LGViewController alloc] init];
  [_window setRootViewController:viewController];

  [_window setBackgroundColor:[UIColor blackColor]];
  [_window makeKeyAndVisible];
  return YES;
}

@end
