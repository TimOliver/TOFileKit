//
//  TOFileLocationsPresenter.h
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

#import "TOFileConstants.h"

@class TOFileLocation;
@class TOFileCoordinator;

NS_ASSUME_NONNULL_BEGIN

/** The types of table cells that this presenter can produce */
typedef NS_ENUM(NSInteger, TOFileLocationsPresenterItemType) {
    TOFileLocationsPresenterItemTypeDefault,     // A single location, added by the user or a local device
    TOFileLocationsPresenterItemTypeAddLocation, // An action button to add a new location
};

@interface TOFileLocationsPresenter : NSObject

#pragma mark - State Management -

/** If we're currently editing */
@property (nonatomic, assign) BOOL editing;

/** If the local devices section should be shown or not */
@property (nonatomic, readonly) BOOL showLocalDevicesSection;

#pragma mark - State Change Alert Handlers -

/** Called when it is time to refresh a section of the table view */
@property (nonatomic, copy) void (^refreshSectionHandler)(NSInteger section);

/** Called when the visiblity of the local devices section needs to be updated. */
@property (nonatomic, copy) void (^localDevicesSectionHiddenHandler)(NSInteger section, BOOL hidden);

/** Called when the 'Edit' button should be disabled. */
@property (nonatomic, copy) void (^editingDisabledHandler)(BOOL);

/** Called when the editing state was enabled or disabled. (Editing, Animated) */
@property (nonatomic, copy) void (^isEditingHandler)(BOOL, BOOL);

#pragma mark - Instance Creation -

/** Create a new instance with the following */
- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator;

#pragma mark - User-Initiated Input Events -

/** Load the accounts from disk */
- (void)fetchAccountsList;

/** Start scanning for local devices */
- (void)startScanningForLocalDevices;

/** Stop scanning for local devices when not needed */
- (void)stopScanningForLocalDevices;

/** Edit Button was tapped */
- (void)toggleEditing;

#pragma mark - Current View State Outputs -

/** The number of visible sections (Should be 1 or 2) */
- (NSInteger)numberOfSections;

/** The number of items in a given section */
- (NSInteger)numberOfItemsForSection:(NSInteger)section;

/** Returns the type of cell to display in this row */
- (TOFileLocationsPresenterItemType)itemTypeForIndex:(NSInteger)index inSection:(NSInteger)section;

/** Returns the name of the location for the given item */
- (NSString *)nameOfItemInIndex:(NSInteger)index section:(NSInteger)section;

/** If desired, a subtitle for the location at the given index */
- (nullable NSString *)descriptionOfItemInIndex:(NSInteger)index section:(NSInteger)section;

/** Returns the service type of the location for the given item */
- (TOFileServiceType)typeOfItemInIndex:(NSInteger)index section:(NSInteger)section;

/** Table View Configuration */
- (NSString *)titleForSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
