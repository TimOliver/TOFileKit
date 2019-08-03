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

// The type of view to display in detail view controller setups
@property (nonatomic, assign) TOFileViewControllerType initialItemType;
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
    if (_isCompactPresentation == isCompactPresentation) { return; }
    _isCompactPresentation = isCompactPresentation;
    
}

- (void)setInitialViewWithType:(TOFileViewControllerType)type object:(id)object
{
    self.initialItemType = type;
    self.initialItemObject = object;

    // Show it immediately, if we're not in iPhone display mode
    if (!self.isCompactPresentation && self.showItemHandler) {
        self.showItemHandler(type, object);
    }
}

- (void)showItemWithType:(TOFileViewControllerType)type object:(id)object
{
    
}

@end
