//
//  TOFileRootPresenter.h
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
#import "TOFileCoordinator+Private.h"
#import "TOFileConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface TOFileRootPresenter : NSObject <TOFileCoordinating>

/** The current view controller type that was selected by the user */
@property (nonatomic, readonly) TOFileViewControllerType itemType;

/** The associated model object (if any) used to populate the item. */
@property (nonatomic, readonly) id itemObject;

/** Whether the current presentation is in compact mode (eg iPhone), or full screen. */
@property (nonatomic, assign) BOOL isCompactPresentation;

/** Callback for presenting views for new items when needed. */
@property (nonatomic, copy) void (^showItemHandler)(TOFileViewControllerType type, _Nullable id object);

/** Set an optional 'initial' item that will only be created and shown when space is available. */
- (void)setInitialItem:(TOFileViewControllerType)type modelObject:(nullable id)object;

/** For all regular interactions, show a child view controller based on the type. */
- (void)showItemWithType:(TOFileViewControllerType)type modelObject:(nullable id)object;

/** When collapsing a split controller, determine if the visible controller should be merged. */
- (BOOL)shouldCollapseVisibleItemsForSplitViewController;

@end

NS_ASSUME_NONNULL_END
