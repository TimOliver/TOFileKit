//
//  TOFileLocationsView.h
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

#import <UIKit/UIKit.h>

@class TOFileSeparatorView;

NS_ASSUME_NONNULL_BEGIN

@interface TOFileLocationsView : UIView

/** Bar button items that says 'Edit' */
@property (nonatomic, readonly) UIBarButtonItem *editButton;

/** Bar button item that says 'Done' */
@property (nonatomic, readonly) UIBarButtonItem *doneButton;

/** The main content view */
@property (nonatomic, readonly) UITableView *tableView;

/** The separator view kept under the top header bar */
@property (nonatomic, readonly) TOFileSeparatorView *separatorView;

/** Callback from when the edit/done button is tapped */
@property (nonatomic, copy) void (^editButtonTapped)(void);

@end

NS_ASSUME_NONNULL_END
