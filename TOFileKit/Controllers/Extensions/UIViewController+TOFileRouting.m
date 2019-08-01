//
//  UIViewController+TOFileRouting.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 2/8/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "UIViewController+TOFileRouting.h"

@implementation UIViewController (TOFileRouting)

- (void)to_showViewControllerOfType:(TOFileViewControllerType)type withObject:(id)object
{
    // Navigate up the chain to find a controller that overrides this method
    UIViewController *viewController = [self targetViewControllerForAction:@selector(to_showViewControllerOfType:withObject:)
                                                                    sender:self];
    // View controller must be headless
    if (viewController == nil) { return; }

    // Call the method to trigger that view controller to present
    [viewController to_showViewControllerOfType:type withObject:object];
}

@end
