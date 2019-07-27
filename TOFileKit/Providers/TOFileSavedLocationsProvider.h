//
//  TOFileSavedLocationsProvider.h
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
#import <Realm/Realm.h>
#import "TOFileCoordinator+Private.h"

@class TOFileLocation;

NS_ASSUME_NONNULL_BEGIN

/**
 A class dedicated to managing the flow of data in and out of the
 file locations view controller (As opposed to the presenter, which
 transforms the data here for presentation on the screen).
 */
@interface TOFileSavedLocationsProvider : NSObject <TOFileCoordination>

/** A Realm collection of all of the locations saved by the user. */
@property (nonatomic, readonly) id<RLMCollection> locations;

/** A list of all local devices on the network that may be accessible. */
@property (nonatomic, readonly) NSArray *localDevices;

/** A block that is called each time the `locations` property is updated by the data store. */
@property (nonatomic, copy) void (^locationsChangedHandler)(NSArray *insertions,
                                                            NSArray *changes,
                                                            NSArray *deletions);

/** A block that is called each time the local devices on the network change. */
@property (nonatomic, copy) void (^localDevicesChangedHandler)(void);

/** Explicitly trigger the provider to start querying for file locations. */
- (void)loadLocationsFromDisk;

/** A file coordinator is absolutely necessary for this class */
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
