//
//  TOFileLocationsView.m
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

#import "TOFileUtilities.h"

#import "TOFileLocationsView.h"
#import "TOFileSeparatorView.h"
#import "TOFileOnboardingView.h"

@interface TOFileLocationsView ()

@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong, readwrite) UIBarButtonItem *editButton;
@property (nonatomic, strong, readwrite) UIBarButtonItem *doneButton;
@property (nonatomic, strong, readwrite) TOFileSeparatorView *separatorView;
@property (nonatomic, strong, readwrite) TOFileOnboardingView *onboardingView;

@end

@implementation TOFileLocationsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit
{
    // Configure the view itself
    self.backgroundColor = [UIColor whiteColor];

    // Configure and add table view
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.preservesSuperviewLayoutMargins = YES;
    tableView.cellLayoutMarginsFollowReadableWidth = NO;
    tableView.delaysContentTouches = NO;
    [self addSubview:tableView];
    self.tableView = tableView;

    // Configure the edit button
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                target:self
                                                                                action:@selector(editStateButtonTapped:)];
    self.editButton = editButton;

    // Configure the done button
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(editStateButtonTapped:)];
    self.doneButton = doneButton;

    // Configure the separator view
    self.separatorView = [[TOFileSeparatorView alloc] initWithFrame:CGRectZero];
    [self.tableView addSubview:self.separatorView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.separatorView sizeToFitInView:self];
    CGRect frame = self.separatorView.frame;
    frame.origin.x = self.layoutMargins.left;
    frame.origin.y = 1.0f;
    self.separatorView.frame = frame;
}

- (void)editStateButtonTapped:(id)sender
{
    if (self.editButtonTapped) { self.editButtonTapped(); }
}

- (TOFileOnboardingView *)onboardingView
{
    if (_onboardingView) { return _onboardingView; }

    NSBundle *bundle    = TOFileKitBundleForObject(self);
    NSString *title     = TOFileKitLocalized(@"FileLocations.Empty.Title", bundle);
    NSString *message   = TOFileKitLocalized(@"FileLocations.Empty.Message", bundle);

    _onboardingView = [[TOFileOnboardingView alloc] initWithTitle:title message:message];
    _onboardingView.buttonTitle = TOFileKitLocalized(@"FileLocations.AddNewLocation", bundle);
    return _onboardingView;
}

@end
