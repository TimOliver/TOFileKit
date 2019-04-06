//
//  TOLocalServiceDiscovery.m
//
//  Copyright 2016-2019 Timothy Oliver. All rights reserved.
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

#import "TOLocalServiceDiscovery.h"

@interface TOLocalServiceDiscovery () <NSNetServiceBrowserDelegate>

// One service browser per the type we want to scan for.
@property (nonatomic, strong) NSArray<NSNetServiceBrowser *> *serviceBrowsers;

// A mutable version of the array that we will store the services we get back from Bonjour
@property (nonatomic, strong, readwrite) NSMutableArray<NSNetService *> *services;

// Whether the discovery object is actively running or not
@property (nonatomic, assign, readwrite) BOOL isRunning;

@end

@implementation TOLocalServiceDiscovery

#pragma mark - Class Creation -

- (instancetype)initWithSearchServiceTypes:(NSArray<NSString *> *)searchServiceTypes
{
    if (self = [super init]) {
        _searchServiceTypes = [searchServiceTypes copy];
    }

    return self;
}

#pragma mark - Discovery Control -

- (void)startDiscovery
{
    if (self.isRunning) { return; }

    // Clear out any previous service records
    self.serviceBrowsers = nil;
    if (self.serviceListUpdatedHandler) {
        self.serviceListUpdatedHandler();
    }

    // Start scanning for local services
    [self prepareAndStartServiceBrowsers];
}

- (void)endDiscovery
{
    if (!self.isRunning) { return; }
    [self removeAllServiceBrowsers];
}

#pragma mark - Internal Browser Management -

- (void)prepareAndStartServiceBrowsers
{
    if (self.serviceBrowsers.count > 0) { return; }

    NSMutableArray *browsers = [NSMutableArray array];

    for (NSString *serviceType in self.searchServiceTypes) {
        NSNetServiceBrowser *browser = [[NSNetServiceBrowser alloc] init];
        browser.delegate = self;
        [browser searchForServicesOfType:serviceType inDomain:@""];
        [browsers addObject:browser];
    }

    self.serviceBrowsers = [browsers copy];
}

- (void)removeAllServiceBrowsers
{
    if (self.serviceBrowsers.count <= 0) { return; }

    for (NSNetServiceBrowser *browser in self.serviceBrowsers) {
        [browser stop];
    }

    self.serviceBrowsers = nil;
}

#pragma mark - Net Service Browser Delegate -
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing
{
    // Create an array to store these services on the first time.
    if (!self.services) { self.services = [NSMutableArray array]; }

    // Skip this service if it's already in the list
    if ([self.services indexOfObject:service] != NSNotFound) { return; }

    // Add the service to the list
    [(NSMutableArray *)self.services addObject:service];

    // Alert the refresh handler block
    if (self.serviceListUpdatedHandler) {
        self.serviceListUpdatedHandler();
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing
{
    if (!self.services) { return; }

    // Skip if we never added this service to begin
    if ([self.services indexOfObject:service] == NSNotFound) { return; }

    // Remove the object from our list
    [(NSMutableArray *)self.services removeObject:service];

    // Alert the refresh handler block
    if (self.serviceListUpdatedHandler) {
        self.serviceListUpdatedHandler();
    }
}

#pragma mark - Accessors -

- (void)setSearchServiceTypes:(NSArray<NSString *> *)searchServiceTypes
{
    if (searchServiceTypes == _searchServiceTypes) { return; }

    BOOL running = self.isRunning;
    [self removeAllServiceBrowsers];

    _searchServiceTypes = [searchServiceTypes copy];

    if (running) {
        [self prepareAndStartServiceBrowsers];
    }
}

@end
