//
//  TOFileTableViewCell.m
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

#import "TOFileTableViewCell.h"
#import "TOFileSeparatorView.h"

@implementation TOFileTableViewCell

#pragma mark - View Creation

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit
{
    self.detailTextLabel.textColor = [UIColor colorWithWhite:0.5f alpha:1.0f];

    self.separatorView = [[TOFileSeparatorView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.separatorView];
}

#pragma mark - View Layout -

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat textHorizontalOrigin = CGRectGetMinX(self.textLabel.frame);
    [(TOFileSeparatorView *)self.separatorView sizeToFitInView:self horizontalOrigin:textHorizontalOrigin];

    CGRect frame = self.separatorView.frame;
    frame.origin.x   = textHorizontalOrigin;
    frame.origin.y   = self.frame.size.height - frame.size.height;
    self.separatorView.frame = frame;

    // Don't bother centering the labels if the detail label is hidden
    if (self.detailTextLabel.text.length == 0) { return; }

    CGFloat halfCellHeight = (self.contentView.frame.size.height * 0.5f);
    CGFloat lineSpacing = 1.0f;

    // Work out the total height the centered content will be
    CGFloat totalHeight = self.textLabel.frame.size.height +
                            self.detailTextLabel.frame.size.height +
                            lineSpacing;

    frame = self.textLabel.frame;
    frame.origin.y = halfCellHeight - (totalHeight * 0.5f);
    self.textLabel.frame = CGRectIntegral(frame);

    frame = self.detailTextLabel.frame;
    frame.origin.y = CGRectGetMaxY(self.textLabel.frame) + lineSpacing;
    self.detailTextLabel.frame = CGRectIntegral(frame);
}

@end
