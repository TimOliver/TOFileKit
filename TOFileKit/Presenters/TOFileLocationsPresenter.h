//
//  TOFileLocationsPresenter.h
//  TOFileKitExample
//
//  Created by Tim Oliver on 31/12/18.
//  Copyright © 2018 Tim Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TOFileLocationsPresenter : NSObject

/** State Management */
@property (nonatomic, assign) BOOL editing;

/** Callbacks from the presenter */

/** Called when it is time to refresh the table view */
@property (nonatomic, copy) void (^refreshSectionHandler)(NSInteger);

/** Called when the 'Edit' button should be disabled. */
@property (nonatomic, copy) void (^editingDisabledHandler)(BOOL);

/** Called when the editing state was enabled or disabled. */
@property (nonatomic, copy) void (^isEditingHandler)(BOOL);

// INPUTS

/** Load the accounts from disk */
- (void)fetchAccountsList;

/** Start scanning for local devices */
- (void)startScanningForLocalDevices;

/** Edit Button was tapped */
- (void)toggleEditing;

// OUTPUTS

/** Table View Data */
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsForSection:(NSInteger)section;
- (NSString *)titleForSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
