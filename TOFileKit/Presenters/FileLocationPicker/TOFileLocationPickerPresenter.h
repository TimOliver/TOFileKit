//
//  TOFileLocationPickerPresenter.h
//  TOFileKitExample
//
//  Created by Tim Oliver on 30/6/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TOFileConstants.h"

@class TOFileCoordinator;

NS_ASSUME_NONNULL_BEGIN

@interface TOFileLocationPickerPresenter : NSObject

/* Number of sections */
- (NSInteger)numberOfSections;

/* Number of items in each section */
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

/* The name of the item at the specific location */
- (NSString *)nameOfItemInSection:(NSInteger)section atIndex:(NSInteger)index;

/** The service type of the location for the given item */
- (TOFileServiceType)typeOfItemInIndex:(NSInteger)index section:(NSInteger)section;

/** Create a new instance with the provided file coordinator */
- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator;

@end

NS_ASSUME_NONNULL_END
