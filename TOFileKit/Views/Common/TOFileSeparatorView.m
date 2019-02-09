//
//  TOFileSeparatorView.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 9/2/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "TOFileSeparatorView.h"

@implementation TOFileSeparatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = nil;
    }

    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (!backgroundColor) {
        backgroundColor = [UIColor colorWithRed:0.7843137255f green:0.7803921569f blue:0.8f alpha:1.0f];
    }

    [super setBackgroundColor:backgroundColor];
}

- (void)sizeToFitInView:(UIView *)view
{
    CGRect frame = CGRectZero;
    frame.size.height = 1.0f / [UIScreen mainScreen].nativeScale;

    UIEdgeInsets margins = view.layoutMargins;
    frame.size.width = view.frame.size.width;
    frame.size.width -= (margins.left + margins.right);
    self.frame = frame;
}

@end
