//
//  LGViewController.m
//  Lights
//
//  Created by Nathan Borror on 9/7/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "LGViewController.h"
#import "UIBigSwitch.h"

@implementation LGViewController {
  UIBigSwitch *_bigSwitch;
  BOOL _paired;
  UIAlertView *_pairAlert;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  _bigSwitch = [[UIBigSwitch alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds)/2)-64, (CGRectGetHeight(self.view.bounds)/2)-100, 128, 200)];
  [_bigSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_bigSwitch];

  _pairAlert = [[UIAlertView alloc] initWithTitle:@"Pair with Hue" message:@"Press the pairing button on your Hue hub then press OK." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];

  [self refresh];
}

- (void)refresh
{
  NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip_preference"];
  NSString *requestBody = @"{\"devicetype\":\"Lights App\", \"username\":\"newdeveloper\"}";
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api", ip]];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"POST"];
  [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];

  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode != 200) return;

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"JSON: %@", json);

    for (NSDictionary *dict in json) {
      if (dict[@"error"][@"type"]) {
        _paired = NO;
      } else {
        _paired = YES;
      }
    }

    if (!_paired) {
//      [_pairAlert show];
    }
  }];
  [task resume];
}

- (void)switchChange:(UIBigSwitch *)aSwitch
{
  NSString *requestBody;

  if (aSwitch.on) {
    requestBody = @"{\"on\":true, \"bri\":255}";
  } else {
    requestBody = @"{\"on\":false}";
  }

  NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip_preference"];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/newdeveloper/groups/0/action", ip]];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"PUT"];
  [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];

  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSString *output = [[NSString alloc] initWithData:(NSMutableData *)data encoding:NSUTF8StringEncoding];
    NSLog(@"SWITCH: %@", output);
  }];
  [task resume];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex) {
    [self refresh];
  }
}

@end
