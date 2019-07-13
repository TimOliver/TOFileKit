//
//  TOFileNavigationBar.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 13/7/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "TOFileNavigationBar.h"

@interface TOFileNavigationBar ()

@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation TOFileNavigationBar

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];

    // Remove the default content
    self.shadowImage = [[UIImage alloc] init];
    [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];

    // Create new blur background
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // Re-align the blur view underneath the status bar
    CGRect barFrame = self.frame;
    CGRect frame = self.backgroundView.frame;
    frame = barFrame;
    frame.origin.y = -barFrame.origin.y;
    frame.size.height += barFrame.origin.y;
    self.backgroundView.frame = frame;

    // Ensure it is positioned behind all other content
    [self insertSubview:self.backgroundView atIndex:0];
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    self.backgroundView.backgroundColor = barTintColor;
}

- (UIColor *)barTintColor
{
    return self.backgroundView.backgroundColor;
}

@end
