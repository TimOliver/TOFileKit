//
//  ICLocalServiceDiscoveryManager.m
//  iComics
//
//  Created by Tim Oliver on 18/01/2016.
//  Copyright © 2016 Timothy Oliver. All rights reserved.
//

#import "ICLocalServiceDiscoveryManager.h"

#import "ICDownloadService.h"
#import "ICNetworkDownloadService.h"

#import "ICLocalService.h"
#import "Reachability.h"

#import <TOSMBClient/TOSMBClient.h>

const CGFloat kICServiceUpdateDelay = 0.5f;

@interface ICLocalServiceDiscoveryManager () <NSNetServiceBrowserDelegate>

@property (nonatomic, strong, readwrite) NSMutableArray *services;
@property (nonatomic, strong) NSMutableArray *pendingAddedServices;
@property (nonatomic, strong) NSMutableArray *pendingRemovedServices;
@property (nonatomic, strong) Reachability *reachability;

@property (nonatomic, strong) NSMutableArray *serviceBrowsers;
@property (nonatomic, strong) TONetBIOSNameService *netBIOSService;

@property (nonatomic, strong) NSTimer *nextUpdateTimer;

/* NetBIOS Callback Methods */
- (void)didAddNetBIOSEntry:(TONetBIOSNameServiceEntry *)entry;
- (void)didRemoveNetBIOSEntry:(TONetBIOSNameServiceEntry *)entry;

/* Add a new object to the list, and sort it. */
- (void)addNewServiceObject:(ICLocalService *)service;

/* Schedule the feedback block to be called in periodic chunks. */
- (void)scheduleUpdateBlockTrigger;
- (void)performUpdateBlock;

@end

@implementation ICLocalServiceDiscoveryManager

- (instancetype)init
{
    if (self = [super init]) {
        _reachability = [Reachability reachabilityForLocalWiFi];
    }
    
    return self;
}

- (void)dealloc
{
    [self endServiceDiscovery];
}

#pragma mark - External State Handling -
- (void)beginServiceDiscovery
{
    if (self.serviceBrowsers || self.netBIOSService) {
        return;
    }
    
    self.services = [NSMutableArray array];
    self.pendingAddedServices = [NSMutableArray array];
    self.pendingRemovedServices = [NSMutableArray array];
    
    //set up the service browsers and begin searching
    if (self.serviceBrowsers == nil) {
        self.serviceBrowsers = [NSMutableArray array];
        
        for (Class service in [ICDownloadService networkProtocolServices]) {
            if ([service serviceType] == ICDownloadServiceTypeSMB) {
                continue;
            }
        
            NSNetServiceBrowser *browser = [[NSNetServiceBrowser alloc] init];
            browser.delegate = self;
            [browser searchForServicesOfType:[service netServiceType] inDomain:@"local."];
            [self.serviceBrowsers addObject:browser];
        }
    }
    
    if (self.netBIOSService == nil) {
        self.netBIOSService = [[TONetBIOSNameService alloc] init];
    }
    
    __weak typeof(self) weakSelf = self;
    id addedEntryHandler = ^(TONetBIOSNameServiceEntry *entry) { [weakSelf didAddNetBIOSEntry:entry]; };
    id removedEntryHandler = ^(TONetBIOSNameServiceEntry *entry) { [weakSelf didRemoveNetBIOSEntry:entry]; };
    [self.netBIOSService startDiscoveryWithTimeOut:5.0f added:addedEntryHandler removed:removedEntryHandler];
    
    id reachabilityHandler = ^(Reachability *reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (reachability.isReachableViaWiFi) {
                [weakSelf beginServiceDiscovery];
            }
            else {
                [weakSelf endServiceDiscovery];
            }
        });
    };
    self.reachability.reachableBlock = reachabilityHandler;
    self.reachability.unreachableBlock = reachabilityHandler;
    [self.reachability startNotifier];
    
    if (self.servicesListUpdatedHandler) {
        self.servicesListUpdatedHandler();
    }
}

- (void)endServiceDiscovery
{
    for (NSNetServiceBrowser *browser in self.serviceBrowsers) {
        [browser stop];
    }
    self.serviceBrowsers = nil;
    
    [self.netBIOSService stopDiscovery];
    self.netBIOSService = nil;
    
    self.services = nil;
    if (self.servicesListUpdatedHandler) {
        self.servicesListUpdatedHandler();
    }
    
    [self.nextUpdateTimer invalidate];
    self.nextUpdateTimer = nil;
}

#pragma mark - Add New Object -
- (void)addNewServiceObject:(ICLocalService *)service
{
    //If the name is blank, forget it
    if ([service.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        return;
    }
    
    NSComparator comparator = ^(ICLocalService *obj1, ICLocalService *obj2) {
        return [obj1.name compare:obj2.name];
    };
    
    NSInteger index = [self.services indexOfObject:service
                                     inSortedRange:(NSRange){0, self.services.count}
                                     options:NSBinarySearchingInsertionIndex
                                     usingComparator:comparator];
                                         
    [self.services insertObject:service atIndex:index];
}

#pragma mark - Service Callbacks -
- (void)didAddNetBIOSEntry:(TONetBIOSNameServiceEntry *)entry
{
    ICLocalService *service = [[ICLocalService alloc] initWithNetBIOSEntry:entry];
    if ([self.services indexOfObject:service] != NSNotFound) {
        return;
    }
    
    [self.pendingAddedServices addObject:service];
    [self scheduleUpdateBlockTrigger];
}

- (void)didRemoveNetBIOSEntry:(TONetBIOSNameServiceEntry *)entry
{
    ICLocalService *service = [[ICLocalService alloc] initWithNetBIOSEntry:entry];
    NSInteger index = [self.services indexOfObject:service];
    if (index == NSNotFound) {
        return;
    }
    
    [self.pendingRemovedServices addObject:service];
    [self scheduleUpdateBlockTrigger];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing
{
    ICLocalService *localService = [[ICLocalService alloc] initWithNetService:service];
    if ([self.services indexOfObject:localService] != NSNotFound) {
        return;
    }
    
    [self.pendingAddedServices addObject:localService];
    [self scheduleUpdateBlockTrigger];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing
{
    ICLocalService *localService = [[ICLocalService alloc] initWithNetService:service];
    NSInteger index = [self.services indexOfObject:localService];
    if (index == NSNotFound) {
        return;
    }
    
    [self.pendingRemovedServices addObject:localService];
    [self scheduleUpdateBlockTrigger];
}

- (void)scheduleUpdateBlockTrigger
{
    if (self.nextUpdateTimer) {
        return;
    }
    
    self.nextUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:kICServiceUpdateDelay target:self selector:@selector(performUpdateBlock) userInfo:nil repeats:NO];
}

- (void)performUpdateBlock
{
    //Add all of the new objects
    for (ICLocalService *service in self.pendingAddedServices) {
        [self addNewServiceObject:service];
    }
    [self.pendingAddedServices removeAllObjects];
    
    //Remove all pending objects
    [self.services removeObjectsInArray:self.pendingRemovedServices];
    [self.pendingRemovedServices removeAllObjects];
    
    //Trigger the update block
    if (self.servicesListUpdatedHandler) {
        self.servicesListUpdatedHandler();
    }
    
    //remove the timer in preparation of next time
    self.nextUpdateTimer = nil;
}

#pragma mark - Accessors -
- (BOOL)discoveryAvailable
{
    return [self.reachability isReachableViaWiFi];
}

@end
