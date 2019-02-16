//
//  TOFileLocationsPresenter.m
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

#import "TOFileLocationsPresenter.h"
#import "TOFileCoordinator.h"

typedef NS_ENUM(NSInteger, TOFileLocationsPresenterSection) {
    TOFileLocationsPresenterSectionLocations = 0,
    TOFileLocationsPresenterSectionLocalDevices = 1
};

@interface TOFileLocationsPresenter ()

@property (nonatomic, strong) TOFileCoordinator *fileCoordinator;

@end

@implementation TOFileLocationsPresenter

- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator
{
    if (self = [super init]) {
        _fileCoordinator = fileCoordinator;
    }

    return self;
}

#pragma mark - User Interaction -

- (void)toggleEditing
{
    self.editing = !self.editing;
    if (self.isEditingHandler) { self.isEditingHandler(self.editing, YES); }
}

#pragma mark - Collection View Configuration -

- (NSInteger)numberOfSections
{
    return 2;
}

- (NSInteger)numberOfItemsForSection:(NSInteger)section
{
    return 1;
}

- (NSString *)titleForSection:(NSInteger)section
{
    if (section == 1) {
        return NSLocalizedString(@"Local Devices", @"File Accounts Title");
    }
    
    return NSLocalizedString(@"Locations", @"File Accounts Title");
}

#pragma mark - Collection View Data -
- (TOFileLocationsPresenterItemType)itemTypeForIndex:(NSInteger)index inSection:(NSInteger)section
{
    // For displaying the accounts the user saved
    if (section == TOFileLocationsPresenterSectionLocations) {
        return TOFileLocationsPresenterItemTypeAddLocation;
    }

    // For scanning for local devices
    return TOFileLocationsPresenterItemTypeScanning;
}

@end
