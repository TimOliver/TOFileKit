//
//  TOFileLocationPickerPresenter.h
//  TOFileKitExample
//
//  Created by Tim Oliver on 30/6/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TOFileConstants.h"
#import "TOFileCoordinator+Private.h"

NS_ASSUME_NONNULL_BEGIN

@interface TOFileLocationPickerPresenter : NSObject <TOFileCoordination>

/* Number of sections */
- (NSInteger)numberOfSections;

/* Number of items in each section */
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

/* The name of the item at the specific location */
- (NSString *)nameOfItemInSection:(NSInteger)section atIndex:(NSInteger)index;

/** The service type of the location for the given item */
- (TOFileServiceType)typeOfItemInSection:(NSInteger)section atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
