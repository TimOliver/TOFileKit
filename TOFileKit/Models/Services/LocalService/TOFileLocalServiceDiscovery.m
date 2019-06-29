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

#import "TOFileLocalServiceDiscovery.h"

@interface TOFileLocalServiceDiscovery () <NSNetServiceBrowserDelegate>

// An internal dictionary to uniquely store all of the services.
@property (nonatomic, strong) NSMutableDictionary *servicesDictionary;

// One service browser per the type we want to scan for.
@property (nonatomic, strong) NSArray<NSNetServiceBrowser *> *serviceBrowsers;

// A statuc array that we will publicly expose the services we get back from Bonjour
@property (nonatomic, strong, readwrite) NSArray<NSNetService *> *services;

// Whether the discovery object is actively running or not
@property (nonatomic, assign, readwrite) BOOL isRunning;

// An dispatch queue that we use to offload generating the services array
@property (nonatomic, strong) dispatch_queue_t servicesQueue;

// A dispatch queue used to make the services dictionary thread-safe
@property (nonatomic, strong) dispatch_queue_t serviceDictionaryQueue;

// A timer used to periodically refresh the public services list
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TOFileLocalServiceDiscovery

#pragma mark - Class Creation -

- (instancetype)initWithSearchServiceTypes:(NSArray<NSString *> *)searchServiceTypes
{
    if (self = [super init]) {
        _searchServiceTypes = [searchServiceTypes copy];
        [self commonInit];
    }

    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit
{
    _servicesDictionary = [NSMutableDictionary dictionary];
    _rateTimeLimit = 0.25f;
    _servicesQueue = dispatch_queue_create("dev.tim.localServiceDiscovery.servicesQueue", DISPATCH_QUEUE_SERIAL);
    _serviceDictionaryQueue = dispatch_queue_create("dev.tim.localServiceDiscovery.serviceDictionaryQueue", DISPATCH_QUEUE_CONCURRENT);
}

#pragma mark - Discovery Control -

- (void)start
{
    if (self.isRunning) { return; }

    // Clear out any previous service records
    self.serviceBrowsers = nil;

    // Set up all of the service browsers
    [self prepareServiceBrowsers];

    // Start running all of the service browsers
    [self startAllServiceBrowsers];

    // Set running flag
    self.isRunning = YES;
}

- (void)stop
{
    if (!self.isRunning) { return; }

    // Stop all of the browsers
    [self stopAllServiceBrowsers];

    // Set no running flag
    self.isRunning = NO;
}

- (void)reset
{
    [self removeAllServiceBrowsers];
    self.services = nil;
}

#pragma mark - Service Browser Management -

- (void)prepareServiceBrowsers
{
    if (self.serviceBrowsers.count > 0) { return; }

    NSMutableArray *browsers = [NSMutableArray array];

    for (NSInteger i = 0; i < self.searchServiceTypes.count; i++) {
        NSNetServiceBrowser *browser = [[NSNetServiceBrowser alloc] init];
        browser.delegate = self;
        [browsers addObject:browser];
    }

    self.serviceBrowsers = [browsers copy];
}

- (void)startAllServiceBrowsers
{
    if (self.serviceBrowsers.count == 0) { return; }

    NSInteger i = 0;
    for (NSString *serviceType in self.searchServiceTypes) {
        [self.serviceBrowsers[i] searchForServicesOfType:serviceType inDomain:@""];
        i++;
    }
}

- (void)stopAllServiceBrowsers
{
    if (self.serviceBrowsers.count <= 0) { return; }

    for (NSNetServiceBrowser *browser in self.serviceBrowsers) {
        [browser stop];
    }
}

- (void)removeAllServiceBrowsers
{
    [self stopAllServiceBrowsers];
    self.serviceBrowsers = nil;
}

#pragma mark - Net Service Browser Delegate -
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing
{
    // Add the service to the dictionary.
    // (Storing it via its hash efficiently ensures no duplicates)
    dispatch_barrier_async(self.serviceDictionaryQueue, ^{
        self.servicesDictionary[@(service.hash)] = service;
    });

    // If one hasn't been started yet, kickstart a new timer to coalesce all of these service calls
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.rateTimeLimit
                                                      target:self
                                                    selector:@selector(servicesTimerDidTrigger)
                                                    userInfo:nil
                                                     repeats:NO];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing
{
    // Remove the object from the dictionary
    dispatch_barrier_async(self.serviceDictionaryQueue, ^{
        [self.servicesDictionary removeObjectForKey:@(service.hash)];
    });

    // If one hasn't been started yet, kickstart a new timer to coalesce all of these service calls
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.rateTimeLimit
                                                      target:self
                                                    selector:@selector(servicesTimerDidTrigger)
                                                    userInfo:nil
                                                     repeats:NO];
    }
}

#pragma mark - Service Batch Coalescing -

- (void)servicesTimerDidTrigger
{
    // Offload the work to generate a new services list to the background
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.servicesQueue, ^{
        [weakSelf updateServicesList];
    });

    // Set the timer to nil so we can repeat the process if need be
    self.timer = nil;
}

- (void)updateServicesList
{
    // Extract all of the services from the array
    __block NSMutableArray *services = nil;
    dispatch_sync(self.serviceDictionaryQueue, ^{
        services = self.servicesDictionary.allValues.mutableCopy;
    });

    // Sort them all by name
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [services sortUsingDescriptors:@[nameSortDescriptor]];

    // Update the public facing list from the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        self.services = [NSArray arrayWithArray:services];

        if (self.servicesListChangedHandler) {
            self.servicesListChangedHandler();
        }
    });
}

#pragma mark - Accessors -

- (void)setSearchServiceTypes:(NSArray<NSString *> *)searchServiceTypes
{
    if (searchServiceTypes == _searchServiceTypes) { return; }

    BOOL running = self.isRunning;
    [self removeAllServiceBrowsers];

    _searchServiceTypes = [searchServiceTypes copy];

    if (running) {
        [self prepareServiceBrowsers];
        [self startAllServiceBrowsers];
    }
}

@end
