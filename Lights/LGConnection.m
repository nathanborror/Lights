//
//  LGConnection.m
//  Lights
//
//  Created by Nathan Borror on 9/8/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "LGConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation LGConnection {
  NSURLConnection *_internalConnection;
  NSMutableData *_container;
}

- (id)initWithRequest:(NSURLRequest *)req completion:(void (^)(id, NSError *))block
{
  if (self = [super init]) {
    [self setRequest:req];
    [self setCompletionBlock:block];
  }
  return self;
}

- (void)start
{
  _container = [[NSMutableData alloc] init];
  _internalConnection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:YES];

  if (!sharedConnectionList) {
    sharedConnectionList = [[NSMutableArray alloc] init];
  }
  [sharedConnectionList addObject:self];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [_container appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  if (_completionBlock) {
    _completionBlock(_container, nil);
  }

  [sharedConnectionList removeObject:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  if (_completionBlock) {
    _completionBlock(nil, error);
  }
  [sharedConnectionList removeObject:self];
}

@end
