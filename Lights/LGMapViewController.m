//
//  LGMapViewController.m
//  Lights
//
//  Created by Nathan Borror on 3/27/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import "LGMapViewController.h"
#import "LGOverlay.h"
#import "LGLocationStore.h"
#import "LGPlotter.h"

@implementation LGMapViewController {
  CLLocationManager *_locationManager;
  MKMapView *_map;
  LGPlotter *_plotter;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.view setBackgroundColor:[UIColor whiteColor]];

  UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
  [self.navigationItem setRightBarButtonItem:done];

  UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
  [self.navigationItem setLeftBarButtonItem:cancel];

  // Show a map
  _map = [[MKMapView alloc] initWithFrame:self.view.bounds];
  [_map setMapType:MKMapTypeStandard];
  [_map setShowsUserLocation:YES];
  [_map setDelegate:self];
  [self.view addSubview:_map];

  _plotter = [[LGPlotter alloc] initWithFrame:CGRectMake(32, 96, CGRectGetWidth(self.view.bounds)-64, CGRectGetWidth(self.view.bounds)-64)];
  [self.view addSubview:_plotter];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];

  NSArray *regions = [[LGLocationStore sharedStore] allRegions];

  // Add overlays to map
  NSMutableArray *overlays = [NSMutableArray array];
  for (CLCircularRegion *region in regions) {
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:region.center radius:region.radius];
    [overlays addObject:circle];
  }
  [_map addOverlays:overlays];

  // Orient the map
  [_map setRegion:MKCoordinateRegionMake([(CLCircularRegion *)[regions firstObject] center], MKCoordinateSpanMake(0.005, 0.005))];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleDefault;
}

- (void)done
{
//  [_locationManager startMonitoringForRegion:region];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
  if ([overlay isKindOfClass:[MKCircle class]]) {
    MKCircleRenderer *view = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    [view setFillColor:[UIColor colorWithWhite:0 alpha:.2]];
    return view;
  }
  return nil;
}

@end
