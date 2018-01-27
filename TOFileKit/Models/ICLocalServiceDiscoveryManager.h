//
//  ICLocalServiceDiscoveryManager.h
//  iComics
//
//  Created by Tim Oliver on 18/01/2016.
//  Copyright © 2016 Timothy Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICLocalService;

@interface ICLocalServiceDiscoveryManager : NSObject

/* The list of services discovered by the manager. */
@property (nonatomic, readonly) NSMutableArray<ICLocalService *> *services;

/* A block triggered each time the number of items in `services` changes. */
@property (nonatomic, copy) void (^servicesListUpdatedHandler)();

/* A quick check to see if it's possible to perform discovery (ie WiFi is present) */
@property (nonatomic, readonly) BOOL discoveryAvailable;

/* Begin device discovery */
- (void)beginServiceDiscovery;

/* Stop device discovery and completely deallocate everything */
- (void)endServiceDiscovery;

@end
