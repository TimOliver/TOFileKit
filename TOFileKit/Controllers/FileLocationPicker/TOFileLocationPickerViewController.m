//
//  TOFileLocationPickerViewController.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 30/6/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "TOFileLocationPickerViewController.h"
#import "TOFileCoordinator.h"
#import "TOFileLocationPickerView.h"
#import "TORoundedTableView.h"
#import "TOFileLocationImage.h"

@interface TOFileLocationPickerViewController ()  <UITableViewDelegate, UITableViewDataSource>

/** The coordinator used to track the state we're displaying */
@property (nonatomic, strong, readwrite) TOFileCoordinator *fileCoordinator;

/** A convenience method for mapping this view controller's view to our type */
@property (nonatomic, readonly) TOFileLocationPickerView *pickerView;

/** A dictionary holding all of the service images we support. */
@property (nonatomic, strong) NSDictionary *serviceIcons;

@end

@implementation TOFileLocationPickerViewController

#pragma mark - Controller Creation -

- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator
{
    if (self = [super init]) {
        _fileCoordinator = fileCoordinator;
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

    // Load the service icons
    self.serviceIcons = [TOFileLocationImage allImagesDictionary];

    // Link the table view to this controller
    TORoundedTableView *tableView = self.pickerView.tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = self.pickerView.backgroundColor;
}

#pragma mark - Table View Data Source -

#pragma mark - Internal Accessors -

- (TOFileLocationPickerView *)pickerView
{
    return (TOFileLocationPickerView *)self.view;
}

@end
