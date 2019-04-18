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
#import "TOFileLocationImage.h"

NSInteger const kTOFileLocationsMaximumLocalServices = 6;
NSString * const kTOFileLocationsHeaderIdentifier = @"LocationsHeader";
NSString * const kTOFileLocationsFooterIdentifier = @"LocationsFooter";

@interface TOFileLocationsViewController () <UITableViewDelegate, UITableViewDataSource>

/** The file coordinator in charge of managing state for the whole network. */
@property (nonatomic, strong, readwrite) TOFileCoordinator *fileCoordinator;

/** The presenter object in charge of managing view data to be displayed. */
@property (nonatomic, strong, readwrite) TOFileLocationsPresenter *presenter;

/** Convenience accessor since `self.view` won't access the properties. */
@property (nonatomic, readonly) TOFileLocationsView *fileLocationsView;

/** A dictionary of all of the icons for the file services */
@property (nonatomic, strong) NSDictionary *serviceIcons;

@end

@implementation TOFileLocationsViewController

#pragma mark - Class Creation -

- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator
{
    if (self = [super init]) {
        _fileCoordinator = fileCoordinator;
        _presenter = [[TOFileLocationsPresenter alloc] initWithFileCoordinator:_fileCoordinator];
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

    // Load all of the service icons
    self.serviceIcons = [TOFileLocationImage allImagesDictionary];

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

    // Trigger the presenter to start loading saved locations now
    [self.presenter fetchAccountsList];
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

    // Insert or remove the locations section as needed
    self.presenter.localDevicesSectionHiddenHandler = ^(NSInteger section, BOOL hidden) {
        NSIndexSet *sectionIndex = [NSIndexSet indexSetWithIndex:section];
        if (hidden) { [weakView.tableView deleteSections:sectionIndex withRowAnimation:UITableViewRowAnimationFade]; }
        else { [weakView.tableView insertSections:sectionIndex withRowAnimation:UITableViewRowAnimationFade]; }
    };

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Perform device discovery while we are on screen
    [self.presenter startScanningForLocalDevices];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    // Disable device discovery whenever we are off screen
    [self.presenter stopScanningForLocalDevices];
}

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

#pragma mark - Table View Data Source -

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
            [self configureDefaultCell:cell forIndexPath:indexPath];
            break;
        case TOFileLocationsPresenterItemTypeAddLocation:
            cell.type = TOFileLocationsTableViewCellTypeAdd;
            break;
    }

    return cell;
}

- (void)configureDefaultCell:(TOFileLocationsTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger index = indexPath.row;

    cell.type = TOFileLocationsTableViewCellTypeDefault;

    // Set the title of the cell to the name of the item
    NSString *name = [self.presenter nameOfItemInIndex:index section:section];
    cell.textLabel.text = name;

    // Set the detail text item to optionall a description
    NSString *description = [self.presenter descriptionOfItemInIndex:index section:section];
    cell.detailTextLabel.text = description;

    // Set the image view to the service icon
    TOFileServiceType serviceType = [self.presenter typeOfItemInIndex:index section:section];
    cell.imageView.image = self.serviceIcons[@(serviceType)];
}

#pragma mark - Table View Delegate -

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // Hide the separator view in cells at the bottom of the section
    TOFileTableViewCell *fileCell = (TOFileTableViewCell *)cell;
    fileCell.separatorView.hidden = (indexPath.row >= [self.presenter numberOfItemsForSection:indexPath.section] - 1 );
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Exit out if this section doesn't have a title
    NSString *title = [self.presenter titleForSection:section];
    if (!title) { return nil; }

    // Show a large title label as the header view for this section
    TOFileTableSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTOFileLocationsHeaderIdentifier];
    headerView.titleLabel.text = title;
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // Return a section footer view in charge of showing a separator view separating the next section
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTOFileLocationsFooterIdentifier];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return [TOFileTableSectionHeaderView height]; }

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [TOFileTableSectionFooterView height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Convenience Accessors -

- (TOFileLocationsView *)fileLocationsView { return (TOFileLocationsView *)self.view; }

@end
