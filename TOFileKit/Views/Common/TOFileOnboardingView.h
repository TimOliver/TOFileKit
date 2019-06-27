//
//  TOFileOnboardingView.h
//
//  Copyright 2019 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
