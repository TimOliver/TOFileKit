//
//  TOLocalServiceDiscovery.h
//
//  Copyright 2016-2019 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TOLocalServiceDiscovery : NSObject

/** All of the service types the discovery service will look for (Must be formatted like "_http._tcp.") */
@property (nonatomic, copy) NSArray<NSString *> *searchServiceTypes;

/** A list of all of the services discovered so far. */
@property (nonatomic, readonly) NSArray<NSNetService *> *services;

/** A block triggered each time the number of items in `services` changes. */
@property (nonatomic, copy) void (^serviceListUpdatedHandler)(void);

/** Whether the discovery object is currently running or not. */
@property (nonatomic, readonly) BOOL isRunning;

/** Create a new discovery object, and prefill it with the types to search for. */
- (instancetype)initWithSearchServiceTypes:(NSArray<NSString *> *)searchServiceTypes;

/** Begin service discovery. */
- (void)startDiscovery;

/** Stop service discovery. */
- (void)endDiscovery;

@end

NS_ASSUME_NONNULL_END
