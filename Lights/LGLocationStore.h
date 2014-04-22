//
//  LGLocationStore.h
//  Lights
//
//  Created by Nathan Borror on 4/13/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface LGLocationStore : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

+ (LGLocationStore *)sharedStore;

- (NSArray *)allRegions;
- (void)addRegion:(CLCircularRegion *)region;
- (void)removeRegion:(CLCircularRegion *)region;
- (void)clearRegions;

@end
