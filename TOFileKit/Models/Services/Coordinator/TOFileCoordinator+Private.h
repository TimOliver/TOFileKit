//
//  TOFileCoordinator+Private.h
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

// Private API and property exposure for the file coordinator class.

#import "TOFileCoordinator.h"

NS_ASSUME_NONNULL_BEGIN

@class TOFileService;

/**
 A protocol for all objects that work off the data and state provided by
 a `TOFileCoordinator` object and so one *must* be provided upon creation.
 */
@protocol TOFileCoordinating <NSObject>

@required

/**
 Creates a new instance of the assigned class with the provided file coordinator.

 @param fileCoordinator - A file coordinator object that contains all of the current state.
 */
- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator;

@optional

/* The file coordinator serving as the data source for this object. */
@property (nonatomic, readonly) TOFileCoordinator *fileCoordinator;

@end

// ------------------------------------------------------------------

/**
 Private methods and properties for `TOFileCoordinator` that are necessary for
 accessing and transforming the internal state, but not accessible from the public API headers.
 */
@interface TOFileCoordinator (Private)

/** Provided an array of file services types, return a filtered array
    based on the disallowed ones in `disallowedFileServiceTypes`
 */
- (NSArray<TOFileService *> *)filteredDisallowedServicesArrayWithArray:(NSArray<TOFileService *> *)array;

@end

NS_ASSUME_NONNULL_END
