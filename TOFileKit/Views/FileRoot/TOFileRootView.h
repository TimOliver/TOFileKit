//
//  TOFileRootView.h
//  TOFileKitExample
//
//  Created by Tim Oliver on 3/8/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A UIView subclass that manages the outer containing view for
 the `TOFileViewController`.

 A toolbar is present in compact modes that will display the
 'Done' button at the bottom of the screen. On regular modes,
 the bar is hidden.
 */
@interface TOFileRootView : UIView

/**
 The content view, namely the containing view controller
 that is presented by this view.
 */
@property (nonatomic, strong) UIView *contentView;

/**
 The toolbar view displayed along the bottom of the screen.
 */
@property (nonatomic, readonly) UIToolbar *toolbar;

/**
 The height of the toolbar. There can be three different
 values depending if the trait collection has a compact height
 or if the toolbar is hidden.
 */
@property (nonatomic, readonly) CGFloat toolbarHeight;

/** Convenience method to hide the toolbar */
@property (nonatomic, assign) BOOL toolbarHidden;

/** An action trigerred when the done button is tapped. */
@property (nonatomic, copy) void (^doneButtonTapped)(UIBarButtonItem *item);

/** An action triggered when the downloads button is tapped. */
@property (nonatomic, copy) void (^downloadsButtonTapped)(UIBarButtonItem *item);

@end

NS_ASSUME_NONNULL_END
