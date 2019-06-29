//
//  TOFileOnboardingView.m
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

#import "TOFileOnboardingView.h"
#import "TORoundedButton.h"

@interface TOFileOnboardingView ()

@property (nonatomic, assign) CGFloat textSpacing;
@property (nonatomic, assign) CGFloat buttonSpacing;
@property (nonatomic, assign) CGFloat buttonHeight;

// Views
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) TORoundedButton *button;

@end

@implementation TOFileOnboardingView

#pragma mark - Class Creation -

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    if (self = [super initWithFrame:(CGRect){0, 0, 200, 200}]) {
        [self commonInit];
        _titleLabel.text = title;
        _messageLabel.text = message;
    }

    return self;
}

- (void)commonInit
{
    __weak typeof(self) weakSelf = self;
    _textColor = [UIColor blackColor];
    _textSpacing = 6.0f;
    _buttonSpacing = 15.0f;
    _buttonHeight = 40.0f;
    self.layoutMargins = (UIEdgeInsets){20.0f, 30.0f, 20.0f, 30.0f};

    self.backgroundColor = [UIColor clearColor];

    // Add background view
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    self.backgroundView.layer.cornerRadius = 10.0f;
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        self.backgroundView.layer.cornerCurve = kCACornerCurveContinuous;
    }
#endif
    [self addSubview:self.backgroundView];


    // Create a bold, sizable font for the title
    UIFont *titleFont = [UIFont systemFontOfSize:17.0f weight:UIFontWeightBold];
    if (@available(iOS 11.0, *)) {
        UIFontMetrics *metrics = [[UIFontMetrics alloc] initForTextStyle:UIFontTextStyleBody];
        titleFont = [metrics scaledFontForFont:titleFont];
    }

    // Add the title label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = titleFont;
    self.titleLabel.adjustsFontForContentSizeCategory = YES;
    self.titleLabel.textColor = _textColor;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.backgroundColor = self.backgroundView.backgroundColor;
    [self addSubview:self.titleLabel];

    // Add the message label
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.messageLabel.adjustsFontForContentSizeCategory = YES;
    self.messageLabel.textColor = _textColor;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.backgroundColor = self.backgroundView.backgroundColor;
    [self addSubview:self.messageLabel];

    // Add the button
    self.button = [[TORoundedButton alloc] initWithFrame:(CGRect){0,0,300,_buttonHeight}];
    self.button.cornerRadius = 8.0f;
    self.button.tappedHandler = ^{
        if (weakSelf.buttonTappedHandler) { weakSelf.buttonTappedHandler(); }
    };
    [self addSubview:self.button];
}

#pragma mark - View Layout -

- (void)layoutSubviews
{
    [super layoutSubviews];

    // Layout state
    CGRect bounds = self.bounds;
    UIEdgeInsets margins = self.layoutMargins;
    CGSize contentSize = (CGSize){bounds.size.width - (margins.left + margins.right), CGFLOAT_MAX};
    CGRect contentBounds = (CGRect){CGPointZero, contentSize};
    CGFloat y = margins.top;

    // Layout the title label
    CGRect frame = self.titleLabel.frame;
    frame.origin.x = margins.left;
    frame.origin.y = y;
    frame.size.width = contentSize.width;
    frame.size.height = [self.titleLabel textRectForBounds:contentBounds limitedToNumberOfLines:0].size.height;
    self.titleLabel.frame = CGRectIntegral(frame);

    // Increment y
    y = CGRectGetMaxY(frame) + self.textSpacing;

    // Layout the message label
    frame = self.messageLabel.frame;
    frame.origin.x = margins.left;
    frame.origin.y = y;
    frame.size.width = contentSize.width;
    frame.size.height = [self.messageLabel textRectForBounds:contentBounds limitedToNumberOfLines:0].size.height;
    self.messageLabel.frame = CGRectIntegral(frame);

    // Increment y
    y = CGRectGetMaxY(frame) + self.buttonSpacing;

    // Layout the button
    frame = self.button.frame;
    frame.size.width = MIN(contentSize.width, self.button.minimumWidth + 80);
    frame.size.height = _buttonHeight;
    frame.origin.y = y;
    frame.origin.x = CGRectGetMidX(bounds) - (frame.size.width * 0.5f);
    self.button.frame = CGRectIntegral(frame);
}

- (void)sizeToFitWidth:(CGFloat)width
{
    UIEdgeInsets margins = self.layoutMargins;
    width -= (margins.left + margins.right);

    CGSize contentSize = (CGSize){width, CGFLOAT_MAX};
    CGRect bounds = (CGRect){CGPointZero, contentSize};

    // Get base height
    CGFloat height = margins.top;

    // Add the height of the title label
    height += [self.titleLabel textRectForBounds:bounds limitedToNumberOfLines:0].size.height;

    // Add the spacing between labels
    height += _textSpacing;

    // Add the height of the message label
    height += [self.messageLabel textRectForBounds:bounds limitedToNumberOfLines:0].size.height;

    // Add the spacing to the button
    height += _buttonSpacing;

    // Add the height of the button
    height += _buttonHeight;

    // Add the bottom margin
    height += margins.bottom;

    // Set ourselves to the new size
    CGRect frame = self.frame;
    frame.size.height = height;
    frame.size.width = width;
    self.frame = CGRectIntegral(frame);
}

#pragma mark - Accessors -

- (void)setTitle:(NSString *)title { self.titleLabel.text = title; }
- (NSString *)title { return self.titleLabel.text; }

- (void)setMessage:(NSString *)message { self.messageLabel.text = message; }
- (NSString *)message { return self.messageLabel.text; }

- (void)setButtonTitle:(NSString *)buttonTitle { self.button.text = buttonTitle; }
- (NSString *)buttonTitle { return self.button.text; }

@end
