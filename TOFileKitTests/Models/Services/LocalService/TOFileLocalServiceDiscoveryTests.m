//
//  TOFileLocalServiceDiscoveryTests.m
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
#import "TOFileLocalServiceDiscovery.h"

@interface TOFileLocalServiceDiscoveryTests : XCTestCase

@end

@implementation TOFileLocalServiceDiscoveryTests

// Do a basic test to see that the class will properly handle services sent from Bonjour
- (void)testLocalDiscovery
{
    NSArray *serviceTypes = @[@"_smb._tcp."];

    // Allocation
    TOFileLocalServiceDiscovery *discovery = [[TOFileLocalServiceDiscovery alloc] initWithSearchServiceTypes:serviceTypes];
    XCTAssertNotNil(discovery);

    discovery.servicesListAddedHandler = ^(NSNetService *service) {
        XCTAssertNotNil(service);
    };

    // Create a dummy service
    NSNetService *service = [[NSNetService alloc] initWithDomain:@"" type:@"_smb._tcp." name:@"Test"];

    // Expose the protocol conformance of the object so we can trigger a fake service detection
    id<NSNetServiceBrowserDelegate> discoveryDelegate = (id)discovery;
    [discoveryDelegate netServiceBrowser:[[NSNetServiceBrowser alloc] init] didFindService:service moreComing:YES];
}

@end
