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

#import "TOFileCoordinator.h"
#import "TOFileLocationsPresenter.h"
#import "TOFileLocalServiceDiscovery.h"
#import "TOFileService.h"
#import "TOFileCustomService.h"

#import <TOReachability/TOReachability.h>

typedef NS_ENUM(NSInteger, TOFileLocationsPresenterSection) {
    TOFileLocationsPresenterSectionLocations = 0,
    TOFileLocationsPresenterSectionLocalDevices = 1
};

@interface TOFileLocationsPresenter ()

@property (nonatomic, strong, readwrite) TOFileCoordinator *fileCoordinator;
@property (nonatomic, strong) TOFileLocalServiceDiscovery *serviceDiscovery;
@property (nonatomic, strong) TOReachability *reachability;

/** Used to ensure calls to the table view are done in the right order/number */
@property (nonatomic, assign) BOOL localDevicesSectionHidden;

@end

@implementation TOFileLocationsPresenter

- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator
{
    if (self = [super init]) {
        _fileCoordinator = fileCoordinator;
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator
                  localServiceDiscovery:(TOFileLocalServiceDiscovery *)serviceDiscovery
                           reachability:(TOReachability *)reachability
{
    if (self = [super init]) {
        _fileCoordinator = fileCoordinator;
        _serviceDiscovery = serviceDiscovery;
        _reachability = reachability;
        [self commonInit];
    }

    return self;
}

- (void)commonInit
{
    __weak typeof(self) weakSelf = self;

    // Set to hidden by default
    _localDevicesSectionHidden = YES;

    // Configure reachability
    if (_reachability == nil) {
        _reachability = [TOReachability reachabilityForWifiConnection];
    }

    _reachability.statusChangedHandler = ^(TOReachabilityStatus newStatus) {
        BOOL wifiEnabled = (newStatus == TOReachabilityStatusWiFi);
        [weakSelf wifiStatusChanged:wifiEnabled];
    };

    // Configure the service discovery
    if (_serviceDiscovery == nil) {
        NSArray *bonjourServiceTypes = [self bonjourServiceTypesForCoordinator:self.fileCoordinator];
        _serviceDiscovery = [[TOFileLocalServiceDiscovery alloc] initWithSearchServiceTypes:bonjourServiceTypes];
    }

    id servicesListChangedHandler = ^(NSNetService *service) {
        [weakSelf localDevicesListDidUpdate];
    };
    _serviceDiscovery.servicesListAddedHandler = servicesListChangedHandler;
    _serviceDiscovery.servicesListRemovedHandler = servicesListChangedHandler;
}

#pragma mark - User Initiated Input Events -

- (void)fetchAccountsList
{

}

- (void)startScanningForLocalDevices
{
    // Start the reachability object, which will then drive the service discovery
    [self.reachability start];
}

- (void)stopScanningForLocalDevices
{
    // Stop scanning (but don't clear the visible list)
    [self.reachability stop];
}

- (void)toggleEditing
{
    self.editing = !self.editing;
    if (self.isEditingHandler) { self.isEditingHandler(self.editing, YES); }
}

#pragma mark - Local Device Discovery -

- (void)wifiStatusChanged:(BOOL)wifiEnabled
{
    // WiFi was enabled
    if (wifiEnabled) {
        [self.serviceDiscovery start];
        return;
    }

    // WiFi was disabled, completely reset the service discovery
    [self.serviceDiscovery stop];
    [self.serviceDiscovery reset];

    // Reset section visibility to hidden
    if (!self.localDevicesSectionHidden) {
        self.localDevicesSectionHidden = YES;

        // Trigger handler to hide the section if it was available
        if (self.localDevicesSectionHiddenHandler) {
            self.localDevicesSectionHiddenHandler(TOFileLocationsPresenterSectionLocalDevices, YES);
        }
    }
}

- (void)localDevicesListDidUpdate
{
    // If an item was added, but the section is currently set as hidden
    if (self.serviceDiscovery.services.count > 0 && self.localDevicesSectionHidden) {

        // Unhide the section
        self.localDevicesSectionHidden = NO;

        // Trigger the handler to refresh the list
        if (self.self.localDevicesSectionHiddenHandler) {
            self.localDevicesSectionHiddenHandler(TOFileLocationsPresenterSectionLocalDevices, NO);
        }

        // This also refreshes the data source at the same time, so no need to continue
        return;
    }

    // If the number of devices became 0 and the local devices section was visible
    if (self.serviceDiscovery.services.count == 0 && !self.localDevicesSectionHidden) {

        // Set the state to hide the section
        self.localDevicesSectionHidden = YES;

        // Trigger the handler
        if (self.self.localDevicesSectionHiddenHandler) {
            self.localDevicesSectionHiddenHandler(TOFileLocationsPresenterSectionLocalDevices, YES);
        }

        // Again, the insertion call also refreshes the data source
        return;
    }

    // For every other time, call a handler to refresh the visible section
    if (!self.localDevicesSectionHidden && self.refreshSectionHandler) { self.refreshSectionHandler(TOFileLocationsPresenterSectionLocalDevices); }
}

#pragma mark - Input Handling -


#pragma mark - Collection View Configuration -

- (NSInteger)numberOfSections
{
    return self.localDevicesSectionHidden ? 1 : 2;
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
    return TOFileLocationsPresenterItemTypeDefault;
}

#pragma mark - Convenience Methods -
- (NSArray *)bonjourServiceTypesForCoordinator:(TOFileCoordinator *)coordinator
{
    NSMutableArray *types = [NSMutableArray array];
    NSArray *hostedServices = [TOFileService customHostedServices];
    NSArray *disallowedServices = self.fileCoordinator.disallowedFileServiceTypes;

    for (Class service in hostedServices) {
        TOFileServiceType type = [service serviceType];
        if (disallowedServices && [disallowedServices indexOfObject:@(type)] != NSNotFound) {
            continue;
        }
        [types addObject:[service netServiceType]];
    }

    return [NSArray arrayWithArray:types];
}

@end
