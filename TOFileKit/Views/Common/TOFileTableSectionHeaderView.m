//
//  TOFileTableSectionHeaderView.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 10/2/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "TOFileTableSectionHeaderView.h"

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
    UIFont *titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    titleFont = [UIFont systemFontOfSize:titleFont.pointSize weight:UIFontWeightBold];
    self.textLabel.font = titleFont;
}

@end
