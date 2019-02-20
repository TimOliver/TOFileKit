//
//  ICLocalService.h
//  iComics
//
//  Created by Tim Oliver on 18/01/2016.
//  Copyright © 2016 Timothy Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOFileLocalDevice : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *serviceType;
@property (nonatomic, readonly) UIImage *icon;

@property (nonatomic, readonly) NSNetService *netService;
@property (nonatomic, readonly) TONetBIOSNameServiceEntry *netBIOSEntry;

- (instancetype)initWithNetService:(NSNetService *)service;

@end
