//
//  TOFileLocationsPresenterTests.m
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


#import <XCTest/XCTest.h>
#import "TOReachabilityMock.h"
#import "TOFileLocalServiceDiscoveryMock.h"
#import "TOFileLocationsPresenter.h"
#import "TOFileCoordinator.h"

@interface TOFileLocationsPresenterTests : XCTestCase

// Configuration
@property (nonatomic, strong) TOFileCoordinator *coordinator;

// Test object
@property (nonatomic, strong) TOFileLocationsPresenter *locationsPresenter;

// Mock objects
@property (nonatomic, strong) TOFileLocalServiceDiscoveryMock *serviceDiscovery;
@property (nonatomic, strong) TOReachabilityMock *reachability;

@end

@implementation TOFileLocationsPresenterTests

- (void)setUp
{
    self.coordinator = [[TOFileCoordinator alloc] init];
    self.serviceDiscovery = [[TOFileLocalServiceDiscoveryMock alloc] init];
    self.reachability = [[TOReachabilityMock alloc] init];

    self.locationsPresenter = [[TOFileLocationsPresenter alloc] initWithFileCoordinator:self.coordinator
                                                                  localServiceDiscovery:self.serviceDiscovery
                                                                           reachability:self.reachability];
}

// Sanity check to make sure the object was created properly
- (void)testLocationsPresenterObject
{
    XCTAssertNotNil(self.locationsPresenter);
    XCTAssertNotNil(self.locationsPresenter.fileCoordinator);
}

// Test that the correct condition of WiFi enabling, and devices detected triggers the "show" block
- (void)testDetectionOfLocalDevicesAppeared
{
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"The appearence of devices was successfully detected"];

    __weak id weakSelf = self;
    self.locationsPresenter.localDevicesSectionHiddenHandler = ^(NSInteger section, BOOL hidden) {
        id self = weakSelf;
        XCTAssertEqual(section, 1);
        XCTAssertEqual(hidden, NO);
        [expectation fulfill];
    };

    // Start the state for scanning
    [self.locationsPresenter startScanningForLocalDevices];

    // Simulate the reachability detect WiFi
    [self.reachability triggerStatusChange:TOReachabilityStatusWiFi];

    // Trigger we then detected some devices
    [self.serviceDiscovery triggerServicesFoundWithNumber:3];

    // Ensure the expectation is fulfilled
    [self waitForExpectations:@[expectation] timeout:1.0f];
}

// Test that after devices were detected, if the devices are removed, the "hide" block triggers
- (void)testDetectionOfLocalDevicesDisappeared
{
    // Start the state for scanning
    [self.locationsPresenter startScanningForLocalDevices];

    // Simulate the reachability detect WiFi
    [self.reachability triggerStatusChange:TOReachabilityStatusWiFi];

    // Trigger we then detected some devices
    [self.serviceDiscovery triggerServicesFoundWithNumber:3];

    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"All of the devices disappeared"];

    // Set the block now after setting the mock data so we can capture when it disappeares
    __weak id weakSelf = self;
    self.locationsPresenter.localDevicesSectionHiddenHandler = ^(NSInteger section, BOOL hidden) {
        id self = weakSelf;
        XCTAssertEqual(section, 1);
        XCTAssertEqual(hidden, YES);
        [expectation fulfill];
    };

    // Trigger that Bonjour suddenly lost all of the devices
    [self.serviceDiscovery triggerServicesFoundWithNumber:0];

    // Ensure the expectation is fulfilled
    [self waitForExpectations:@[expectation] timeout:1.0f];
}

// Test that after devices were detected, WiFi suddenly terminating will trigger the hide block
- (void)testDetectionOfLocalDevicesWiFiTerminated
{
    // Start the state for scanning
    [self.locationsPresenter startScanningForLocalDevices];

    // Simulate the reachability detect WiFi
    [self.reachability triggerStatusChange:TOReachabilityStatusWiFi];

    // Trigger we then detected some devices
    [self.serviceDiscovery triggerServicesFoundWithNumber:3];

    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"All of the devices disappeared"];

    // Set the block now after setting the mock data so we can capture when it disappeares
    __weak id weakSelf = self;
    self.locationsPresenter.localDevicesSectionHiddenHandler = ^(NSInteger section, BOOL hidden) {
        id self = weakSelf;
        XCTAssertEqual(section, 1);
        XCTAssertEqual(hidden, YES);
        [expectation fulfill];
    };

    // Trigger that WiFi was terminated
    [self.reachability triggerStatusChange:TOReachabilityStatusNotAvailable];

    // Ensure the expectation is fulfilled
    [self waitForExpectations:@[expectation] timeout:1.0f];
}

// After devices were detected, check that the table view data source returns consistent state
- (void)testDetectionOfLocalDevicesDataSource
{
    // Start the state for scanning
    [self.locationsPresenter startScanningForLocalDevices];

    // Simulate the reachability detect WiFi
    [self.reachability triggerStatusChange:TOReachabilityStatusWiFi];

    // Trigger we then detected some devices
    [self.serviceDiscovery triggerServicesFoundWithNumber:3];

    // Section should be visible
    XCTAssert(self.locationsPresenter.numberOfSections == 2);

    // There should be 3 rows in the second section
    XCTAssert([self.locationsPresenter numberOfItemsForSection:1] == 3);
}

@end
