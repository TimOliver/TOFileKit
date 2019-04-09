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

@property (nonatomic, strong) TOFileCoordinator *fileCoordinator;
@property (nonatomic, strong) TOFileLocalServiceDiscovery *serviceDiscovery;
@property (nonatomic, strong) TOReachability *reachability;

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

- (void)commonInit
{
    __weak typeof(self) weakSelf = self;

    // Configure reachability
    _reachability = [TOReachability reachabilityForWifiConnection];
    _reachability.statusChangedHandler = ^(TOReachabilityStatus newStatus) {
        BOOL wifiEnabled = (newStatus == TOReachabilityStatusWiFi);
        [weakSelf wifiStatusChanged:wifiEnabled];
    };

    // Configure the service discovery
    NSArray *bonjourServiceTypes = [self bonjourServiceTypesForFileCoordinator];
    _serviceDiscovery = [[TOFileLocalServiceDiscovery alloc] initWithSearchServiceTypes:bonjourServiceTypes];
    _serviceDiscovery.servicesListChangedHandler = ^(BOOL firstTime) {
        [weakSelf localDevicesDiscoveredWithFirstTime:firstTime];
    };
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

    // WiFi disabled
    [self.serviceDiscovery stop];
    [self.serviceDiscovery reset];

    // Trigger handler to hide the section
    if (self.localDevicesSectionHiddenHandler) {
        self.localDevicesSectionHiddenHandler(TOFileLocationsPresenterSectionLocalDevices, YES);
    }
}

- (void)localDevicesDiscoveredWithFirstTime:(BOOL)firstTime
{
    // The first time a device is added, trigger a separate handler to show the section
    if (firstTime) {
        if (self.self.localDevicesSectionHiddenHandler) {
            self.localDevicesSectionHiddenHandler(TOFileLocationsPresenterSectionLocalDevices, NO);
        }
        return;
    }

    // If the refresh event indicated the number of devices went to 0, send another event to hide the section
    if (self.serviceDiscovery.services.count == 0) {
        if (self.self.localDevicesSectionHiddenHandler) {
            self.localDevicesSectionHiddenHandler(TOFileLocationsPresenterSectionLocalDevices, YES);
        }
        return;
    }

    // For every other time, call a handler to refresh the visible section
    if (self.refreshSectionHandler) { self.refreshSectionHandler(TOFileLocationsPresenterSectionLocalDevices); }
}

#pragma mark - Input Handling -


#pragma mark - Collection View Configuration -

- (NSInteger)numberOfSections
{
    return self.showLocalDevicesSection ? 2 : 1;
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
- (NSArray *)bonjourServiceTypesForFileCoordinator
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

#pragma mark - Accessors -
- (BOOL)showLocalDevicesSection
{
    BOOL wifiOn = (self.reachability.status == TOReachabilityStatusWiFi);
    BOOL devicesFound = (self.serviceDiscovery.services.count > 0);
    return wifiOn && devicesFound;
}

@end
