//
//  TOFileLocationsEmptyView.h
//  TOFileKitExample
//
//  Created by Tim Oliver on 27/6/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 When there are no locations saved, this view
 displays a simple introduction and a call-to-action
 button to get started.
 */
@interface TOFileOnboardingView : UIView

/** The text to display as the title */
@property (nonatomic, copy) NSString *title;

/** The text to display as the message under the title */
@property (nonatomic, copy) NSString *message;

/** The text displayed in the button. */
@property (nonatomic, copy) NSString *buttonTitle;

/** The action to execute when the button is tapped */
@property (nonatomic, copy) void (^buttonTappedHandler)(void);

/** Set the color of the title and the message text */
@property (nonatomic, strong) UIColor *textColor;

@end

NS_ASSUME_NONNULL_END
