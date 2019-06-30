//
//  TOFileTableTitleHeaderView.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 30/6/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "TOFileTableTitleHeaderView.h"

@interface TOFileTableTitleHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, assign) CGFloat textSpacing;

@end

@implementation TOFileTableTitleHeaderView

#pragma mark - View Creation

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    if (self = [super initWithFrame:(CGRect){0,0,320,60}]) {
        _title = title;
        _message = message;
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit
{
    // Create a dynamic font for the title
    UIFont *titleFont = [UIFont systemFontOfSize:28.0f weight:UIFontWeightBold];
    if (@available(iOS 11.0, *)) {
        UIFontMetrics *metrics = [[UIFontMetrics alloc] initForTextStyle:UIFontTextStyleTitle1];
        titleFont = [metrics scaledFontForFont:titleFont];
    }

    // Create the title label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = titleFont;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = self.title;
    self.titleLabel.backgroundColor = self.backgroundColor;
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];

    // Create the message label
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.backgroundColor = self.backgroundColor;
    self.messageLabel.textColor = [UIColor blackColor];
    self.messageLabel.text = self.message;
    self.messageLabel.numberOfLines = 0;
    [self addSubview:self.messageLabel];

    // Common properties setup
    _textSpacing = 5.0f;
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Content Layout -

- (void)layoutSubviews
{
    [super layoutSubviews];

    // View constants
    CGFloat midX = CGRectGetMidX(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);

    // Work out the available size we can afford for the content
    UIEdgeInsets margins = self.layoutMargins;
    CGSize contentSize = (CGSize){width - (margins.left + margins.right), CGFLOAT_MAX};
    CGRect contentBounds = (CGRect){CGPointZero, contentSize};

    // Update y to include the height of previous views
    CGFloat y = margins.top;

    // Lay out the title label
    CGRect frame = self.titleLabel.frame;
    frame.size = [self.titleLabel textRectForBounds:contentBounds limitedToNumberOfLines:0].size;
    frame.origin.x = midX - (frame.size.width * 0.5f);
    frame.origin.y = y;
    self.titleLabel.frame = CGRectIntegral(frame);

    y += CGRectGetMaxY(frame) + self.textSpacing;

    // Lay out the message label
    frame = self.messageLabel.frame;
    frame.size = [self.messageLabel textRectForBounds:contentBounds limitedToNumberOfLines:0].size;
    frame.origin.x = midX - (frame.size.width * 0.5f);
    frame.origin.y = y;
    self.messageLabel.frame = CGRectIntegral(frame);
}

- (void)sizeToFitInWidth:(CGFloat)width
{
    // Work out the available size we can afford for the content
    UIEdgeInsets margins = self.layoutMargins;
    CGSize contentSize = (CGSize){width - (margins.left + margins.right), CGFLOAT_MAX};
    CGRect contentBounds = (CGRect){CGPointZero, contentSize};

    // Set up the new frame
    CGRect frame = self.frame;
    frame.size.width = width;

    // Start with the outer level margins
    frame.size.height = margins.top + margins.bottom;

    // Add the height of the title
    frame.size.height += [self.titleLabel textRectForBounds:contentBounds
                                     limitedToNumberOfLines:0].size.height;

    // Add the spacing between the two labels
    frame.size.height += self.textSpacing;

    // Add the message label size
    frame.size.height += [self.messageLabel textRectForBounds:contentBounds
                                       limitedToNumberOfLines:0].size.height;

    // Resize ourselves back to that size
    self.frame = frame;
}

#pragma mark - Accessors -

- (void)setTitleColor:(UIColor *)titleColor { self.titleLabel.textColor = titleColor; }
- (UIColor *)titleColor { return self.titleLabel.textColor; }

- (void)setMessageColor:(UIColor *)messageColor { self.messageLabel.textColor = messageColor; }
- (UIColor *)messageColor { return self.messageLabel.textColor; }

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.titleLabel.backgroundColor = backgroundColor;
    self.messageLabel.backgroundColor = backgroundColor;
}

@end
