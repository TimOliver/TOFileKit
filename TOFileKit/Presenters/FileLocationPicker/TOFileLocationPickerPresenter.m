//
//  TOFileLocationPickerPresenter.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 30/6/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "TOFileLocationPickerPresenter.h"
#import "TOFileCoordinator.h"
#import "TOFileCoordinator+Private.h"
#import "TOFileService.h"

@interface TOFileLocationPickerPresenter ()

/** The file coordinator */
@property (nonatomic, strong) TOFileCoordinator *fileCoordinator;

/** An array of all of the allowed cloud services */
@property (nonatomic, strong) NSArray<TOFileService *> *cloudServices;

/** An array of all of the custom hosted services */
@property (nonatomic, strong) NSArray<TOFileService *> *customHostedServices;

@end

@implementation TOFileLocationPickerPresenter

- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator
{
    if (self = [super init]) {
        _fileCoordinator = fileCoordinator;

        // Load the list of cloud services, and then filter out any disallowed ones
        _cloudServices = [TOFileService cloudHostedServices];
        _cloudServices = [_fileCoordinator filteredDisallowedServicesArrayWithArray:_cloudServices];

        // Load the list of custom hosted services, and then filter the list
        _customHostedServices = [TOFileService customHostedServices];
        _customHostedServices = [_fileCoordinator filteredDisallowedServicesArrayWithArray:_customHostedServices];
    }

    return self;
}

- (NSInteger)numberOfSections
{
    return 2;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [self arrayForSection:section].count;
}

- (NSString *)nameOfItemInSection:(NSInteger)section atIndex:(NSInteger)index
{
    return [self arrayForSection:section][index].name;
}

- (TOFileServiceType)typeOfItemInSection:(NSInteger)section atIndex:(NSInteger)index
{
    return [self arrayForSection:section][index].serviceType;
}

#pragma mark - Private Implementation Details -
- (NSArray<TOFileService *> *)arrayForSection:(NSInteger)section
{
    return section == 1 ? self.customHostedServices : self.cloudServices;
}

@end
