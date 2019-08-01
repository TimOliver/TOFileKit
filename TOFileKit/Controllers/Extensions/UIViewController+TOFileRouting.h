//
//  UIViewController+TOFileRouting.h
//  TOFileKitExample
//
//  Created by Tim Oliver on 2/8/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TOFileViewControllerType) {
    TOFileViewControllerTypeAddLocation,
    TOFileViewControllerTypeLocation
};

NS_ASSUME_NONNULL_BEGIN

/**
 A very rudimentary router based on the VIPER principles that
 a top level controller handles navigation state.
 */
@interface UIViewController (TOFileRouting)

/**
 When called, this method is forwarded up the view controller chain until
 it finds a method overriding it. It then calls the same method on that
 view controller to handle the presentation logic of the UI component.

 @param type The inteded type of view controller to show.
 @param object If the view controller relies on a data source, this can be forwarded with it
 */
- (void)to_showViewControllerOfType:(TOFileViewControllerType)type withObject:(nullable id)object;

@end

NS_ASSUME_NONNULL_END
