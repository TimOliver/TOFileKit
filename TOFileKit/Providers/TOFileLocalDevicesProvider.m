//
//  TOFileLocalDevicesProvider.m
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

#import "TOFileLocalDevicesProvider.h"
#import "TOFileLocalServiceDiscovery.h"
#import "TOFileCustomService.h"
#import "TOFileLocation.h"

@interface TOFileLocalDevicesProvider ()

@property (nonatomic, assign, readwrite) BOOL isRunning;
@property (nonatomic, strong) TOFileLocalServiceDiscovery *serviceDiscovery;
@property (nonatomic, strong) NSDictionary *serviceClassDictionary;

@end

@implementation TOFileLocalDevicesProvider

#pragma mark - Class Life Cycle -

- (instancetype)initWithServiceClasses:(NSArray<Class> *)serviceClasses
{
    if (self = [super init]) {
        _serviceClasses = [serviceClasses copy];
    }

    return self;
}

#pragma mark - Class Control

- (void)start
{
    if (self.isRunning) { return; }
}

- (void)stop
{
    if (!self.isRunning) { return; }
}

#pragma mark - Internal Logisitics -

// For faster look-up, map each of the location types to their Bonjour service type
- (NSDictionary *)newServiceClassDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    for (Class serviceClass in self.serviceClasses) {
        if ([serviceClass isKindOfClass:[TOFileCustomService class]]) {
            @throw [NSException
                    exceptionWithName:NSInternalInconsistencyException
                    reason:@"TOFileLocalDevicesProvider: Only classes of type TOFileCustomService may be used."
                    userInfo:nil];
        }

        NSString *serviceType = [serviceClass netServiceType];
        dict[serviceType] = serviceClass;
    }

    // Make non-mutable
    return [NSDictionary dictionaryWithDictionary:dict];
}

// When a service is detected, map it to a location entity for the presenter to use
- (TOFileLocation *)newLocationForBonjourService:(NSNetService *)service
{
    TOFileLocation *location = [[TOFileLocation alloc] init];
    return location;
}

@end
