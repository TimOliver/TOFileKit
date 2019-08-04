//
//  TOFileRootView.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 3/8/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "TOFileRootView.h"

static const CGFloat kTOFileRootTabBarHeightRegular = 44.0f;
static const CGFloat kTOFileRootTabBarHeightCompact = 30.0f;

@interface TOFileRootView ()

@property (nonatomic, strong, readwrite) UIToolbar *toolbar;

@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *downloadsButton;

@end

@implementation TOFileRootView

#pragma mark - View Creation -

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit
{
    // Create and add the toolbar
    self.toolbar = [[UIToolbar alloc] init];
    [self addSubview:self.toolbar];

    // Create the toolbar items
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                    target:self
                                                                    action:@selector(barButtonTapped:)];

    // Create the downloads button
    self.downloadsButton = [[UIBarButtonItem alloc] initWithTitle:@"Downloads"
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(barButtonTapped:)];

    // Pass the buttons to the toolbar
    UIBarButtonItem *spacingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];

    self.toolbar.items = @[self.doneButton, spacingItem, self.downloadsButton];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.toolbarHidden = (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular);
}

#pragma mark - View Layout -

- (void)layoutSubviews
{
    [super layoutSubviews];

    // Insert and align the main content view
    CGRect viewFrame = self.bounds;
    self.contentView.frame = viewFrame;
    [self insertSubview:self.contentView atIndex:0];

    // Layout the toolbar
    CGRect frame = CGRectZero;
    frame.size.height = self.toolbarHeight;
    frame.size.width = viewFrame.size.width;
    if (@available(iOS 11.0, *)) {
        frame.origin.y = viewFrame.size.height - self.safeAreaInsets.bottom;
    }
    else {
        frame.origin.y = (viewFrame.size.height - self.toolbarHeight);
    }
    self.toolbar.frame = frame;
}

#pragma mark - Interaction -

- (void)barButtonTapped:(id)sender
{
    // Done button
    if (sender == self.doneButton && self.doneButtonTapped) {
        self.doneButtonTapped(sender);
    }

    // Downloads button
    if (sender == self.downloadsButton && self.downloadsButtonTapped) {
        self.downloadsButtonTapped(sender);
    }
}

#pragma mark - Environment Changes -

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    self.toolbarHidden = (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular);
}

#pragma mark - Accessors -

- (void)setContentView:(UIView *)contentView
{
    if (contentView == _contentView) { return; }
    _contentView = contentView;
    [self insertSubview:_contentView atIndex:0];
}

- (void)setToolbarHidden:(BOOL)toolbarHidden
{
    self.toolbar.hidden = toolbarHidden;
}

- (BOOL)toolbarHidden { return self.toolbar.hidden; }

- (CGFloat)toolbarHeight
{
    // Height is 0 if the toolbar is hidden
    if (self.toolbarHidden) { return 0.0f; }

    // When the vertical class is compact (eg, an iPhone rotated sideways),
    // use the ultra short height
    UIUserInterfaceSizeClass verticalClass = self.traitCollection.verticalSizeClass;
    if (verticalClass == UIUserInterfaceSizeClassCompact) {
        return kTOFileRootTabBarHeightCompact;
    }

    // Use the regular height for most cases
    return kTOFileRootTabBarHeightRegular;
}

@end
