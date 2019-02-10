//
//  TOFileTableSectionHeaderView.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 10/2/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "TOFileTableSectionHeaderView.h"

CGFloat const kTOFileTableHeaderSectionViewVerticalPadding = 15.0f;

@interface TOFileTableSectionHeaderView ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@end

@implementation TOFileTableSectionHeaderView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor whiteColor];

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = [TOFileTableSectionHeaderView titleFont];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.backgroundColor = [UIColor whiteColor];

    [self.contentView addSubview:self.titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize boundSize = self.contentView.bounds.size;

    [self.titleLabel sizeToFit];

    CGRect frame = self.titleLabel.frame;
    frame.origin.x = self.layoutMargins.left;
    frame.origin.y = (boundSize.height - frame.size.height) * 0.5f;
    self.titleLabel.frame = CGRectIntegral(frame);
}

#pragma mark - Static Methods -

+ (UIFont *)titleFont
{
    // Get the current system font size for this preset, then use that to create a bold version
    UIFont *titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    return [UIFont systemFontOfSize:titleFont.pointSize weight:UIFontWeightBold];
}

+ (CGFloat)height
{
    UIFont *titleFont = [TOFileTableSectionHeaderView titleFont];
    return titleFont.ascender + (kTOFileTableHeaderSectionViewVerticalPadding * 2.0f);
}

@end
