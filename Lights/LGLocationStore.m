//
//  LGLocationStore.m
//  Lights
//
//  Created by Nathan Borror on 4/13/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import "LGLocationStore.h"

@implementation LGLocationStore {
  NSArray *_geofences;
}

- (instancetype)init
{
  if (self = [super init]) {
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
  }
  return self;
}

+ (LGLocationStore *)sharedStore
{
  static LGLocationStore *store = nil;
  if (!store) {
    store = [[LGLocationStore alloc] init];
  }
  return store;
}

- (NSArray *)allRegions
{
  return [_locationManager.monitoredRegions allObjects];
}

- (void)addRegion:(CLCircularRegion *)region
{
  [_locationManager startMonitoringForRegion:region];
}

- (void)removeRegion:(CLCircularRegion *)region
{
  [_locationManager stopMonitoringForRegion:region];
}

- (void)clearRegions
{
  NSArray *regions = [_locationManager.monitoredRegions allObjects];
  for (CLRegion *region in regions) {
    [_locationManager stopMonitoringForRegion:region];
  }
}

- (void)localPush:(NSString *)message
{
  UILocalNotification *notif = [[UILocalNotification alloc] init];
  [notif setAlertBody:message];
  [notif setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
  [notif setTimeZone:[NSTimeZone defaultTimeZone]];
  [[UIApplication sharedApplication] setScheduledLocalNotifications:@[notif]];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
  [self localPush:[NSString stringWithFormat:@"Did enter region (%@)", region.identifier]];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
  [self localPush:[NSString stringWithFormat:@"Did exit region (%@)", region.identifier]];
}

@end
