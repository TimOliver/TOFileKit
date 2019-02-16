//
//  TOFileLocationsViewController.m
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

#import "TOFileLocationsViewController.h"
#import "TOFileLocationsView.h"
#import "TOFileLocationsPresenter.h"
#import "TOFileLocationsTableViewCell.h"
#import "TOFileTableSectionHeaderView.h"
#import "TOFileTableSectionFooterView.h"

NSInteger const kTOFileLocationsMaximumLocalServices = 6;
NSString * const kTOFileLocationsHeaderIdentifier = @"LocationsHeader";
NSString * const kTOFileLocationsFooterIdentifier = @"LocationsFooter";

@interface TOFileLocationsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readwrite) TOFileLocationsPresenter *presenter;

/** Convenience accessor since `self.view` won't access the properties. */
@property (nonatomic, readonly) TOFileLocationsView *fileLocationsView;

@end

@implementation TOFileLocationsViewController

#pragma mark - Class Creation -

- (instancetype)init
{
    if (self = [super init]) {
        _presenter = [[TOFileLocationsPresenter alloc] init];
    }
    
    return self;
}

- (instancetype)initWithPresenter:(TOFileLocationsPresenter *)presenter
{
    if (self = [super init]) {
        _presenter = presenter;
    }
    
    return self;
}

#pragma mark - View Creation -

- (void)loadView
{
    self.view = [[TOFileLocationsView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure this view
    self.title = NSLocalizedString(@"Download", @"Title for Downloads Controller");

    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    }
    
    // Attach table view to us
    self.fileLocationsView.tableView.delegate = self;
    self.fileLocationsView.tableView.dataSource = self;

    // Register the header and footer views for the table view
    [self.fileLocationsView.tableView registerClass:[TOFileTableSectionHeaderView class]
                 forHeaderFooterViewReuseIdentifier:kTOFileLocationsHeaderIdentifier];
    [self.fileLocationsView.tableView registerClass:[TOFileTableSectionFooterView class]
                 forHeaderFooterViewReuseIdentifier:kTOFileLocationsFooterIdentifier];
    
    // Add bar button items
    self.navigationItem.rightBarButtonItem = self.fileLocationsView.editButton;
    self.fileLocationsView.editButton.enabled = NO;
    
    // Now the view is loaded, hook up the interaction logic
    [self bindViewCallbacks];
    [self bindPresenterCallbacks];
}

- (void)bindViewCallbacks
{
    __weak typeof(self) weakSelf = self;

    // Toggle the edit state depending on the presenter
    self.fileLocationsView.editButtonTapped = ^{ [weakSelf.presenter toggleEditing]; };
}

- (void)bindPresenterCallbacks
{
    __weak typeof(self) weakSelf = self;
    __weak typeof(self.fileLocationsView) weakView = self.fileLocationsView;
    
    // Reload sections of the table view when the data changes
    self.presenter.refreshSectionHandler = ^(NSInteger section) {
        [weakView.tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
                          withRowAnimation:UITableViewRowAnimationFade];
    };
    
    // When the Edit button was tapped
    self.presenter.isEditingHandler = ^(BOOL editing, BOOL animated) {
        [weakSelf setEditing:editing animated:animated];
    };
    
    // When the edit button is enabled or disabled
    self.presenter.editingDisabledHandler = ^(BOOL enabled) {
        weakSelf.navigationItem.rightBarButtonItem.enabled = enabled;
    };
}

#pragma mark - View State Management -

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    // Set the table view to be animation
    [self.fileLocationsView.tableView setEditing:editing animated:animated];
    
    // Toggle the Edit button
    TOFileLocationsView *view = self.fileLocationsView;
    UIBarButtonItem *editingButton = editing ? view.doneButton : view.editButton;
    [self.navigationItem setRightBarButtonItem:editingButton animated:animated];
}

#pragma mark - Table View DataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return self.presenter.numberOfSections; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.presenter numberOfItemsForSection:section];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    TOFileLocationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TOFileLocationsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    // Get the type of cell we are supposed to show from the presenter, and map it to the types the table cell supports
    TOFileLocationsPresenterItemType itemType = [self.presenter itemTypeForIndex:indexPath.row inSection:indexPath.section];
    switch (itemType) {
        default:
        case TOFileLocationsPresenterItemTypeDefault:
        case TOFileLocationsPresenterItemTypeLocalDevice:
            cell.type = TOFileLocationsTableViewCellTypeDefault;
            break;
        case TOFileLocationsPresenterItemTypeScanning:
            cell.type = TOFileLocationsTableViewCellTypeScanning;
            break;
        case TOFileLocationsPresenterItemTypeAddLocation:
            cell.type = TOFileLocationsTableViewCellTypeAdd;
            break;
        case TOFileLocationsPresenterItemTypeScanFailure:
            cell.type = TOFileLocationsTableViewCellTypeFailed;
            break;
    }

    return cell;
}

#pragma mark - Table View Delegate -

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // Hide the separator view in cells at the bottom of the section
    TOFileTableViewCell *fileCell = (TOFileTableViewCell *)cell;
    fileCell.separatorView.hidden = ([self.presenter numberOfItemsForSection:indexPath.section] >= indexPath.row - 1);
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = [self.presenter titleForSection:section];
    if (!title) { return nil; }

    TOFileTableSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTOFileLocationsHeaderIdentifier];
    headerView.titleLabel.text = title;
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTOFileLocationsFooterIdentifier];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return [TOFileTableSectionHeaderView height]; }

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section >= [self.presenter numberOfSections] - 1) {
        return 0.0f;
    }

    return [TOFileTableSectionFooterView height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Convenience Accessors -

- (TOFileLocationsView *)fileLocationsView { return (TOFileLocationsView *)self.view; }

@end
