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

@class TOFileLocation;
@class TOFileCoordinator;

NS_ASSUME_NONNULL_BEGIN

/** The types of table cells that this presenter can produce */
typedef NS_ENUM(NSInteger, TOFileLocationsPresenterItemType) {
    TOFileLocationsPresenterItemTypeDefault,     // A single location, added by the user
    TOFileLocationsPresenterItemTypeAddLocation, // An action button to add a new location
    TOFileLocationsPresenterItemTypeLocalDevice, // A local device detected on the network
    TOFileLocationsPresenterItemTypeScanning,    // When scanning for local devices
    TOFileLocationsPresenterItemTypeScanFailure  // When scanning failed (No devices found / no network)
};

@interface TOFileLocationsPresenter : NSObject

/** State Management */
@property (nonatomic, assign) BOOL editing;

/** Callbacks from the presenter */

/** Called when it is time to refresh the table view */
@property (nonatomic, copy) void (^refreshSectionHandler)(NSInteger);

/** Called when the 'Edit' button should be disabled. */
@property (nonatomic, copy) void (^editingDisabledHandler)(BOOL);

/** Called when the editing state was enabled or disabled. (Editing, Animated) */
@property (nonatomic, copy) void (^isEditingHandler)(BOOL, BOOL);

/** Create a new instance with the following */
- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator;

/*********************************************
 Inputs
 *********************************************/

/** Load the accounts from disk */
- (void)fetchAccountsList;

/** Start scanning for local devices */
- (void)startScanningForLocalDevices;

/** Edit Button was tapped */
- (void)toggleEditing;

/*********************************************
 Outputs
 *********************************************/

/** Table View Section Data */
- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsForSection:(NSInteger)section;

/** Returns the type of cell to display in this row */
- (TOFileLocationsPresenterItemType)itemTypeForIndex:(NSInteger)index inSection:(NSInteger)section;

/** When showing a cell with a location, this will return the location for it */
- (nullable TOFileLocation *)locationForItem:(NSInteger)item;

/** When showing a cell for a local device on the network */
- (nullable NSNetService *)localServiceForItem:(NSInteger)item;

/** Table View Configuration */
- (NSString *)titleForSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
