//
//  UIViewController+TOFIleSizeClasses.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 6/8/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "UIViewController+TOFIleSizeClasses.h"

@implementation UIViewController (TOFileSizeClasses)

- (BOOL)to_isCompactPresentation
{
    return self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact;
}

@end
