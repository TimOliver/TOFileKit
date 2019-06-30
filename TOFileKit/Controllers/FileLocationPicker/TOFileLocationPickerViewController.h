//
//  TOFileLocationPickerViewController.h
//  TOFileKitExample
//
//  Created by Tim Oliver on 30/6/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TOFileCoordinator;

NS_ASSUME_NONNULL_BEGIN

@interface TOFileLocationPickerViewController : UIViewController

/* The file coordinator serving as the data source for this controller */
@property (nonatomic, strong, readonly) TOFileCoordinator *fileCoordinator;

/**
 Creates a new instance of the file locations picker controller with the provided file coordinator

 @param fileCoordinator - A file coordinator object that contains all of the current locations state.
 */
- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator;

@end

NS_ASSUME_NONNULL_END
