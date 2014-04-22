//
//  LGOverlay.h
//  Lights
//
//  Created by Nathan Borror on 4/13/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

@import Foundation;
@import CoreLocation;
@import MapKit;

@interface LGOverlay : NSObject <MKOverlay>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) MKMapRect boundingMapRect;
@property (nonatomic, strong) CLCircularRegion *region;

- (instancetype)initWithRegion:(CLCircularRegion *)region;

@end
