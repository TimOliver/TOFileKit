//
//  TOFileLocationPickerViewController.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 30/6/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "TOFileConstants.h"
#import "TOFileCoordinator.h"
#import "TOFileLocationImage.h"
#import "TOFileLocationPickerPresenter.h"
#import "TOFileLocationPickerView.h"
#import "TOFileLocationPickerViewController.h"
#import "TORoundedTableView.h"

@interface TOFileLocationPickerViewController ()  <UITableViewDelegate, UITableViewDataSource>

/** The coordinator used to track the state we're displaying */
@property (nonatomic, strong, readwrite) TOFileCoordinator *fileCoordinator;

/** A convenience method for mapping this view controller's view to our type */
@property (nonatomic, readonly) TOFileLocationPickerView *pickerView;

/** A dictionary holding all of the service images we support. */
@property (nonatomic, strong) NSDictionary *serviceIcons;

/** The view presenter holding all of the display logic for this controller */
@property (nonatomic, strong) TOFileLocationPickerPresenter *presenter;

/** A cancel button shown only in compact display modes */
@property (nonatomic, strong) UIBarButtonItem *cancelButton;

@end

@implementation TOFileLocationPickerViewController

#pragma mark - Controller Creation -

- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator
{
    if (self = [super init]) {
        _fileCoordinator = fileCoordinator;
        _presenter = [[TOFileLocationPickerPresenter alloc] initWithFileCoordinator:_fileCoordinator];
    }

    return self;
}

#pragma mark - View Creation -

- (void)loadView
{
    // Give it an arbitrary size to let the views configure them
    self.view = [[TOFileLocationPickerView alloc] initWithFrame:(CGRect){0,0,320,480}];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Explicity remove large titles from this interface
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }

    // Load the service icons
    self.serviceIcons = [TOFileLocationImage allImagesDictionary];

    // Link the table view to this controller
    TORoundedTableView *tableView = self.pickerView.tableView;
    tableView.delegate = self;
    tableView.dataSource = self;

    // Create the cancel button
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                      target:self
                                                                      action:@selector(cancelButtonTapped:)];
}

#pragma mark - View Life Cycle -

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = self.pickerView.backgroundColor;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];

    // Add the cancel button in compact size classes
    BOOL isCompact = self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact;
    self.navigationItem.rightBarButtonItem = isCompact ? self.cancelButton : nil;

    // As it is hidden, inform our parents that the trait collection changed so it may react
    if (self.presentingViewController) {
        [self.presentingViewController traitCollectionDidChange:previousTraitCollection];
    }
}

#pragma mark - Table View Data Source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.presenter.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.presenter numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create identifiers for standard cells and the cells that will show the rounded corners
    static NSString *cellIdentifier     = @"Cell";
    static NSString *capCellIdentifier  = @"CapCell";

    // Work out if this cell needs the top or bottom corners rounded (Or if the section only has 1 row, both!)
    BOOL isTop = (indexPath.row == 0);
    BOOL isBottom = indexPath.row == ([self.presenter numberOfItemsInSection:indexPath.section] - 1);

    // Create a common table cell instance we can configure
    UITableViewCell *cell = nil;

    // If it's a non-cap cell, dequeue one with the regular identifier
    if (!isTop && !isBottom) {
        TORoundedTableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (normalCell == nil) {
            normalCell = [[TORoundedTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }

        cell = normalCell;
    }
    else {
        // If the cell is indeed one that needs rounded corners, dequeue from the pool of cap cells
        TORoundedTableViewCapCell *capCell = [tableView dequeueReusableCellWithIdentifier:capCellIdentifier];
        if (capCell == nil) {
            capCell = [[TORoundedTableViewCapCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:capCellIdentifier];
        }

        // Configure the cell to set the appropriate corners as rounded
        capCell.topCornersRounded = isTop;
        capCell.bottomCornersRounded = isBottom;
        cell = capCell;
    }

    // Add the arrow to the cell
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    // Configure the cell's label
    cell.textLabel.text = [self.presenter nameOfItemInSection:indexPath.section atIndex:indexPath.row];

    // Configure the cell's icon
    TOFileServiceType type = [self.presenter typeOfItemInSection:indexPath.section atIndex:indexPath.row];
    cell.imageView.image = self.serviceIcons[@(type)];
    
    // Configure layout margins
    UIEdgeInsets layoutMargins = cell.layoutMargins;
    layoutMargins.left = 14.0f;
    cell.layoutMargins = layoutMargins;

    // Return the cell
    return cell;
}

#pragma mark - Interaction -

- (void)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Internal Accessors -

- (TOFileLocationPickerView *)pickerView
{
    return (TOFileLocationPickerView *)self.view;
}

@end
