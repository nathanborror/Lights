//
//  LGConnection.h
//  Lights
//
//  Created by Nathan Borror on 9/8/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

@import Foundation;

@interface LGConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(id obj, NSError *error);

- (id)initWithRequest:(NSURLRequest *)req completion:(void(^)(id obj, NSError *error))block;
- (void)start;

@end
