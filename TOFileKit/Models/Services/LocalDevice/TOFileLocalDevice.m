//
//  ICLocalService.m
//  iComics
//
//  Created by Tim Oliver on 18/01/2016.
//  Copyright © 2016 Timothy Oliver. All rights reserved.
//

#import "TOFileLocalDevice.h"

@interface TOFileLocalDevice ()

@property (nonatomic, strong, readwrite) NSNetService *netService;
@property (nonatomic, strong, readwrite) TONetBIOSNameServiceEntry *netBIOSEntry;

@property (nonatomic, strong) Class serviceClass;

- (BOOL)isEqualToService:(ICLocalService *)service;

@end

@implementation TOFileLocalDevice

#pragma mark - Object Creation -
- (instancetype)initWithNetService:(NSNetService *)service
{
    if (self = [super init]) {
        _netService = service;
        
        //Work out the service class matching this service
        for (Class class in [ICDownloadService networkProtocolServices]) {
            if ([[class netServiceType] isEqualToString:service.type]) {
                _serviceClass = class;
                break;
            }
        }
    }
    
    return self;
}

- (instancetype)initWithNetBIOSEntry:(TONetBIOSNameServiceEntry *)entry
{
    if (self = [super init]) {
        _netBIOSEntry = entry;
        _serviceClass = [ICSMBService class];
    }
    
    return self;
}

#pragma mark - Property Access -
- (NSString *)name
{
    if (self.netService)
        return self.netService.name;
    
    return self.netBIOSEntry.name;
}

- (NSString *)serviceType
{
    return [self.serviceClass name];
}

- (UIImage *)icon
{
    return [self.serviceClass icon];
}

#pragma mark - Equality -
- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[ICLocalService class]]) {
        return NO;
    }
    
    return [self isEqualToService:object];
}

- (BOOL)isEqualToService:(ICLocalService *)service
{
    BOOL equalNames = [self.name isEqualToString:service.name];
    BOOL equalType = [self.serviceType isEqualToString:service.serviceType];
    return equalNames && equalType;
}

- (NSUInteger)hash {
    return ([self.name hash] ^ [self.serviceType hash]);
}

@end
