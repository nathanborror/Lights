//
//  LGViewController.m
//  Lights
//
//  Created by Nathan Borror on 9/7/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "LGViewController.h"
#import "LGConnection.h"
#import "UIBigSwitch.h"

@implementation LGViewController {
  NSString *stationIp;
  UIBigSwitch *bigSwitch;
  BOOL paired;
  UIAlertView *pairAlert;
}

- (id)init
{
  if (self = [super init]) {
    stationIp = @"10.0.1.2";
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  bigSwitch = [[UIBigSwitch alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds)/2)-64, (CGRectGetHeight(self.view.bounds)/2)-100, 128, 200)];
  [bigSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:bigSwitch];

  pairAlert = [[UIAlertView alloc] initWithTitle:@"Pair with Hue" message:@"Press the pairing button on your Hue hub then press OK." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];

  [self refresh];
}

- (void)refresh
{
  NSString *requestBody = @"{\"devicetype\":\"Lights App\", \"username\":\"newdeveloper\"}";
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api", stationIp]];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"POST"];
  [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];

  LGConnection *connection = [[LGConnection alloc] initWithRequest:request completion:^(id obj, NSError *error) {
    NSError *jsonError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:(NSMutableData *)obj options:kNilOptions error:&jsonError];
    NSLog(@"JSON: %@", json);

    for (NSDictionary *dict in json) {
      if (dict[@"error"][@"type"]) {
        paired = NO;
      } else {
        paired = YES;
      }
    }

    if (!paired) {
      [pairAlert show];
    }
  }];

  [connection start];
}

- (void)switchChange:(UIBigSwitch *)aSwitch
{
  NSString *requestBody;

  if (aSwitch.on) {
    requestBody = @"{\"on\":true, \"bri\":255}";
  } else {
    requestBody = @"{\"on\":false}";
  }

  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/newdeveloper/groups/0/action", stationIp]];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"PUT"];
  [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];

  LGConnection *connection = [[LGConnection alloc] initWithRequest:request completion:^(id obj, NSError *error) {
    NSString *output = [[NSString alloc] initWithData:(NSMutableData *)obj encoding:NSUTF8StringEncoding];
    NSLog(@"SWITCH: %@", output);
  }];

  [connection start];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  [self refresh];
}

@end
