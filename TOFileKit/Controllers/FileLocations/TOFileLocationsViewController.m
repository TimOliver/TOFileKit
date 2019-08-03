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
#import "TOFileOnboardingView.h"

#import "UIViewController+TOFileRouting.h"

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

    // Configure navigation bar
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    if (@available(iOS 11.0, *)) {
        navigationBar.prefersLargeTitles = YES;
    }
    navigationBar.barTintColor = [UIColor whiteColor];

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
        [UIView performWithoutAnimation:^{
            if (hidden) { [weakView.tableView deleteSections:sectionIndex withRowAnimation:UITableViewRowAnimationFade]; }
            else { [weakView.tableView insertSections:sectionIndex withRowAnimation:UITableViewRowAnimationFade]; }
        }];
    };

    // Reload sections of the table view when the data changes
    self.presenter.refreshSectionHandler = ^(NSInteger section) {
        [UIView performWithoutAnimation:^{
            [weakView.tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
                              withRowAnimation:UITableViewRowAnimationNone];
        }];
    };
    
    // When the Edit button was tapped
    self.presenter.isEditingHandler = ^(BOOL editing, BOOL animated) {
        [weakSelf setEditing:editing animated:animated];
    };
    
    // When the edit button is enabled or disabled
    self.presenter.editingDisabledHandler = ^(BOOL enabled) {
        weakSelf.navigationItem.rightBarButtonItem.enabled = enabled;
    };

    // When a new item is to be shown
    self.presenter.showItemHandler = ^(TOFileLocationsPresenterItemType type, id object, BOOL animated) {
        [weakSelf showItemWithType:type object:object animated:animated];
    };
}

#pragma mark - View State Management -

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Perform device discovery while we are on screen
    [self.presenter startScanningForLocalDevices];

    // Work out the first view we should display
    [self.presenter showInitialItem];
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

#pragma mark - Navigation Interaction -

- (void)showItemWithType:(TOFileLocationsPresenterItemType)type
                  object:(id)object
                animated:(BOOL)animated
{
    // Map the presenter item type to the global view controller type
    TOFileViewControllerType controllerType = TOFileViewControllerTypeLocation;
    switch (type) {
        case TOFileLocationsPresenterItemTypeAddLocation:
            controllerType = TOFileViewControllerTypeAddLocation;
            break;
        default:
            break;
    }

    [self to_showViewControllerOfType:controllerType withObject:object animated:animated];
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
        case TOFileLocationsPresenterItemTypeAddLocationOnboard:
            [self configureOnboardingCell:cell forIndexPath:indexPath];
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

- (void)configureOnboardingCell:(TOFileLocationsTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    TOFileOnboardingView *onboardingView = self.fileLocationsView.onboardingView;

    // Set the cell to be empty
    cell.type = TOFileLocationsTableViewCellTypeOnboard;

    // Add the onboarding view
    cell.onboardView = onboardingView;

    // Configure the tap action if it is not already set
    if (onboardingView.buttonTappedHandler) { return; }

    // When tapped, send a signal to the presenting controller to present the add location dialog
    __weak typeof(self) weakSelf = self;
    onboardingView.buttonTappedHandler = ^{
        [weakSelf to_showViewControllerOfType:TOFileViewControllerTypeAddLocation
                                   withObject:nil
                                     animated:YES];
    };
}

#pragma mark - Table View Delegate -

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // Hide the separator view in the last cell at the bottom of the section
    TOFileTableViewCell *fileCell = (TOFileTableViewCell *)cell;
    fileCell.separatorView.hidden = (indexPath.row >= [self.presenter numberOfItemsForSection:indexPath.section] - 1);
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return [TOFileTableSectionHeaderView height]; }

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return [TOFileTableSectionFooterView height]; }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TOFileLocationsPresenterItemType itemType = [self.presenter itemTypeForIndex:indexPath.row inSection:indexPath.section];

    if (itemType == TOFileLocationsPresenterItemTypeAddLocationOnboard) {
        UIEdgeInsets margins = tableView.layoutMargins;
        CGFloat width = tableView.frame.size.width - (margins.left + margins.right);
        [self.fileLocationsView.onboardingView sizeToFitWidth:width];
        return self.fileLocationsView.onboardingView.frame.size.height;
    }

    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Convenience Accessors -

- (TOFileLocationsView *)fileLocationsView { return (TOFileLocationsView *)self.view; }

@end
