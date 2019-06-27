//
//  TOFileLocationsTableViewCell.m
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

#import "TOFileLocationsTableViewCell.h"

@interface TOFileLocationsTableViewCell ()

@end

@implementation TOFileLocationsTableViewCell

#pragma mark - View Creation -

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }

    return self;
}

#pragma mark - Cell Life Cycle -

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.imageView.image = nil;
    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;
    [self.onboardView removeFromSuperview];
    self.onboardView = nil;
}

#pragma mark - Configure View Content for Style -

- (void)configureForType:(TOFileLocationsTableViewCellType)type
{
    switch (type) {
        case TOFileLocationsTableViewCellTypeDefault:
            [self configureDefaultType];
            break;
        case TOFileLocationsTableViewCellTypeOnboard:
            [self configureOnboardType];
            break;
        case TOFileLocationsTableViewCellTypeAdd:
            [self configureAddType];
            break;
        case TOFileLocationsTableViewCellTypeScanning:
            [self configureScanningType];
            break;
        case TOFileLocationsTableViewCellTypeFailed:
            [self configureFailedType];
            break;
        default:
            break;
    }
}

- (void)configureDefaultType
{
    BOOL darkMode = (_themeStyle != TOFileLocationsTableViewCellTypeDefault);
    self.textLabel.textColor = darkMode ? [UIColor whiteColor] : [UIColor blackColor];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)configureOnboardType
{
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)configureAddType
{
    self.textLabel.textColor = self.tintColor;
    self.textLabel.text = NSLocalizedString(@"Add New Location", "");
}

- (void)configureScanningType
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    BOOL darkMode = (_themeStyle != TOFileLocationsTableViewCellTypeDefault);

    CGFloat white = darkMode ? 0.8f : 0.5f;
    self.textLabel.textColor = [UIColor colorWithWhite:white alpha:1.0f];
    self.textLabel.text = NSLocalizedString(@"Scanning...", "");
}

- (void)configureFailedType
{
    BOOL darkMode = (_themeStyle != TOFileLocationsTableViewCellTypeDefault);
    CGFloat white = darkMode ? 0.8f : 0.5f;
    self.textLabel.textColor = [UIColor colorWithWhite:white alpha:1.0f];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - View Layout -
- (void)setNeedsLayout
{
    [super setNeedsLayout];

    UIEdgeInsets margin = self.layoutMargins;
    CGRect bounds = self.bounds;

    CGRect frame = self.onboardView.frame;
    frame.origin.x = margin.left;
    frame.origin.y = 0.0f;
    frame.size.width = bounds.size.width - (margin.left + margin.right);
    frame.size.height = bounds.size.height;
    self.onboardView.frame = frame;
}

#pragma mark - Accessors -

- (void)setType:(TOFileLocationsTableViewCellType)type
{
    _type = type;
    [self configureForType:_type];
}

- (void)setThemeStyle:(TOFileLocationsTableViewThemeStyle)themeStyle
{
    if (_themeStyle == themeStyle) { return; }
    _themeStyle = themeStyle;
    [self configureForType:self.type];
}

- (void)setOnboardView:(UIView *)onboardView
{
    _onboardView = onboardView;
    [self addSubview:_onboardView];
    [self setNeedsLayout];
}

@end
