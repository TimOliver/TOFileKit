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

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation TOFileLocationsTableViewCell

#pragma mark - View Creation -

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit
{
    [self prepareForReuse];
}

#pragma mark - Cell Life Cycle -

- (void)prepareForReuse
{
    [super prepareForReuse];
    BOOL darkMode = (_themeStyle != TOFileLocationsTableViewCellStyleDefault);
    self.textLabel.textColor = darkMode ? [UIColor whiteColor] : [UIColor blackColor];
    [self.indicatorView stopAnimating];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

#pragma mark - Configure View Content for Style -

- (void)configureForStyle:(TOFileLocationsTableViewCellStyle)style
{
    switch (style) {
        case TOFileLocationsTableViewCellStyleAdd:
            [self configureAddStyle];
            break;
        case TOFileLocationsTableViewCellStyleScanning:
            [self configureScanningStyle];
            break;
        case TOFileLocationsTableViewCellStyleFailed:
            [self configureFailedStyle];
            break;
        default:
            break;
    }
}

- (void)configureAddStyle
{
    self.textLabel.textColor = self.tintColor;
    self.textLabel.text = NSLocalizedString(@"Add New Location", "");
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

- (void)configureScanningStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.indicatorView == nil) {
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicatorView.hidesWhenStopped = YES;
        [self.contentView addSubview:self.indicatorView];
    }

    BOOL darkMode = (_themeStyle != TOFileLocationsTableViewCellStyleDefault);
    self.indicatorView.tintColor = darkMode ? [UIColor whiteColor] : [UIColor grayColor];
    [self.indicatorView startAnimating];
}

- (void)configureFailedStyle
{
    BOOL darkMode = (_themeStyle != TOFileLocationsTableViewCellStyleDefault);
    CGFloat white = darkMode ? 0.8f : 0.4f;
    self.textLabel.textColor = [UIColor colorWithWhite:white alpha:1.0f];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Accessors -

- (void)setStyle:(TOFileLocationsTableViewCellStyle)cellStyle
{
    if (_style == cellStyle) { return; }
    _style = cellStyle;
    [self configureForStyle:_style];
}

- (void)setThemeStyle:(TOFileLocationsTableViewThemeStyle)themeStyle
{
    if (_themeStyle == themeStyle) { return; }
    _themeStyle = themeStyle;
    [self configureForStyle:self.style];
}

@end
