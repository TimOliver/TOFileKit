//
//  TOFileTableSectionFooterView.m
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

#import "TOFileTableSectionFooterView.h"
#import "TOFileSeparatorView.h"

CGFloat const kTOFileTableSectionFooterVerticalPadding = 5.0f;

@interface TOFileTableSectionFooterView ()
@property (nonatomic, strong, readwrite) TOFileSeparatorView *separatorView;
@end

@implementation TOFileTableSectionFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit
{
    self.separatorView = [[TOFileSeparatorView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.separatorView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.separatorView sizeToFitInView:self];

    CGRect frame = self.separatorView.frame;
    frame.origin.y = kTOFileTableSectionFooterVerticalPadding;
    frame.origin.x = self.layoutMargins.left;
    self.separatorView.frame = frame;
}

#pragma mark - Static Accessors -

+ (CGFloat)height
{
    return (kTOFileTableSectionFooterVerticalPadding * 2.0f) + 1.0f;
}

@end
