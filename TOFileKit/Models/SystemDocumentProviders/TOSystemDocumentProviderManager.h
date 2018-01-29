//
//  ICCloudDocumentManager.h
//  icomics
//
//  Created by Tim Oliver on 12/5/14.
//  Copyright (c) 2014 Timothy Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TOSystemDocumentBrowserManager : NSObject

/* Fired when a comic was successfully imported from another document controller */
@property (nonatomic, copy) void (^importSucceededHandler)(void);

/* Fired when everything's completed, whether successful or not. */
@property (nonatomic, copy) void (^completionHandler)(void);

/* Confirm we're on an iOS version that'll support this */
+ (BOOL)isAvailable;

/* Create a new instance with the controller we'll present from */
- (instancetype)initWithParentViewController:(UIViewController *)parentController;

/* Present the controller from a popover controller */
- (void)presentFromBarButtonItem:(UIBarButtonItem *)barItem;

@end
