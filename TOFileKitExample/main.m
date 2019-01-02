//
//  main.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 31/12/17.
//  Copyright © 2017 Tim Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        Class appDelegateClass = NSClassFromString(@"TOTestingAppDelegate");
        if (!appDelegateClass) {
            appDelegateClass = [TOAppDelegate class];
        }
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(appDelegateClass));
    }
}
