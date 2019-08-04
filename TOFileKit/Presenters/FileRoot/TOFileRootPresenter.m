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

#import "TOFileRootPresenter.h"

@interface TOFileRootPresenter ()

// Strong reference to file coordinator
@property (nonatomic, strong) TOFileCoordinator *fileCoordinator;

// The initial view to show by default (And it's accompanying model)
@property (nonatomic, strong) NSNumber *initialItemType;
@property (nonatomic, strong) id initialItemObject;

@end

@implementation TOFileRootPresenter

- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator
{
    if (self = [super init]) {
        _fileCoordinator = fileCoordinator;
    }

    return self;
}

- (void)setIsCompactPresentation:(BOOL)isCompactPresentation
{
    // Update our state to track compact presentation
    if (_isCompactPresentation == isCompactPresentation) { return; }
    _isCompactPresentation = isCompactPresentation;

    // Don't bother continuing if the handler hasn't been set
    if (!self.showItemHandler) { return; }

    // If we went from compact to regular, show the initial view controller now
    if (self.initialItemType && !_isCompactPresentation) {
        self.showItemHandler(self.initialItemType.integerValue, self.initialItemObject, NO);
    }
}

- (void)showItemWithType:(TOFileViewControllerType)type object:(id)object userInitiated:(BOOL)userInitiated
{
    // If NOT user initiated, this is part of the view hierarchy setting itself up.
    // Since we might be on an iPhone, where the detail controller isn't even necessary,
    // save a reference, but defer setting up that view controller until the trait collection
    // actually does change.

    if (!userInitiated) {
        self.initialItemType = @(type);
        self.initialItemObject = object;

        // Show it immediately, if we're not in iPhone display mode
        if (!self.isCompactPresentation) {
            if (self.showItemHandler) { self.showItemHandler(type, object, NO); }
        }

        return;
    }

    // If the user initiated this presentation, the initial data can go now
    self.initialItemType = nil;
    self.initialItemObject = nil;

    // Show the item
    BOOL modal = (type == TOFileViewControllerTypeAddLocation && self.isCompactPresentation);

    self.showItemHandler(type, object, modal);
}

@end
