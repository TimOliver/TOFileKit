//
//  TOFileLocalDevicesProvider.h
//
//  Copyright 2019 Timothy Oliver. All rights reserved.
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

@class TOFileCustomService;
@class TOFileLocation;

NS_ASSUME_NONNULL_BEGIN

/**
 This class manages scanning for local compatible devices on the network,
 and delivering them as potentially persistable location model objects.
*/
@interface TOFileLocalDevicesProvider : NSObject

/** An array of the `TOFileCustomService` classes representing the services we will scan for */
@property (nonatomic, strong) NSArray<Class> *serviceClasses;

/** An array of `TOFileLocation` objects representing the services that were found */
@property (nonatomic, readonly) NSArray<TOFileLocation *> *discoveredLocations;

/** A callback block called whenever a new location is discovered */
@property (nonatomic, copy) void (^newLocationAddedHandler)(TOFileLocation *location, NSInteger index);

/** A callback block called whenever an existing location was removed. */
@property (nonatomic, copy) void (^locationWasRemovedHandler)(NSInteger index);

/** Create a new instance of the provider object, with the service classes of the types we will scan for. */
- (instancetype)initWithServiceClasses:(NSArray<Class> *)serviceClasses;

/** Start scanning for local devices */
- (void)start;

/** Stop scanning */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
