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
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  LGViewController *viewController = [[LGViewController alloc] init];
  [self.window setRootViewController:viewController];

  [self.window setBackgroundColor:[UIColor whiteColor]];
  [self.window makeKeyAndVisible];
  return YES;
}

@end
