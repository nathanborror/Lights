//
//  LGOverlay.m
//  Lights
//
//  Created by Nathan Borror on 4/13/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import "LGOverlay.h"

@implementation LGOverlay

- (instancetype)initWithRegion:(CLCircularRegion *)region
{
  if (self = [super init]) {
    _region = region;
    _coordinate = _region.center;
    _boundingMapRect = MKMapRectMake(0, 0, _region.radius, _region.radius);
  }
  return self;
}

@end
