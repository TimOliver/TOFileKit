//
//  TOFileLocationsViewController.h
//
//  Copyright 2015-2019 Timothy Oliver. All rights reserved.
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

#import "TOFileKit.h"

@class TOFileCoordinator;
@class TOFileLocationsPresenter;

NS_ASSUME_NONNULL_BEGIN

@interface TOFileLocationsViewController : UIViewController

/** The presenter object in charge of driivng the UI of this controller from the business logic */
@property (nonatomic, readonly) TOFileLocationsPresenter *presenter;

/**
 Creates a new instance of the file locations controller with the provided file coordinator

 @param fileCoordinator - A file coordinator object that contains all of the current locations state.
 */
- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator;

@end

NS_ASSUME_NONNULL_END