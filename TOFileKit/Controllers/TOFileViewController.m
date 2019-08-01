//
//  TOFileViewController.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 30/6/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "TOFileCoordinator.h"
#import "TOFileViewController.h"
#import "TOFileLocationsViewController.h"
#import "TOFileNavigationController.h"
#import "TOFileLocationPickerViewController.h"

@interface TOFileViewController ()

@property (nonatomic, strong) TOFileLocationsViewController *locationsController;
@property (nonatomic, strong) TOFileLocationPickerViewController *locationPickerViewController;

@property (nonatomic, strong, readwrite) TOFileCoordinator *fileCoordinator;

@end

@implementation TOFileViewController

#pragma mark - Class Creation -

- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator
{
    if (self = [super init]) {
        _fileCoordinator = fileCoordinator;
        [self commonInit];
        [self makeChildViewControllers];
    }

    return self;
}

- (void)commonInit
{
    // On iOS 13, force this to still be full screen
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}

- (void)makeChildViewControllers
{
    // Left side content, a split view controller hosting the list of locations,
    // and the current location breakdown
    [self makeSplitViewController];

    // Far right column, the activity view controller
    self.activityViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.activityViewController.title = @"Activity";
    TOFileNavigationController *activityNavigationController = [[TOFileNavigationController alloc] initWithRootViewController:self.activityViewController];

    // Set us to the split view
    self.controllers = @[self.downloadSplitController, activityNavigationController];
    self.separatorLineColor = [UIColor whiteColor];
}

- (void)makeSplitViewController
{
    // Far left column, the locations view controller
    self.locationsController = [[TOFileLocationsViewController alloc] initWithFileCoordinator:_fileCoordinator];
    TOFileNavigationController *locationsNavigationController = [[TOFileNavigationController alloc] initWithRootViewController:self.locationsController];

    // Middle column, by default the picker view controller
    self.locationPickerViewController = [[TOFileLocationPickerViewController alloc] initWithFileCoordinator:_fileCoordinator];
    TOFileNavigationController *pickerNavigationController = [[TOFileNavigationController alloc] initWithRootViewController:self.locationPickerViewController];

    // Configure our split view controller to host these controllers
    self.preferredPrimaryColumnWidthFraction = 0.35f;
    self.minimumPrimaryColumnWidth = 320.0f;
    self.maximumPrimaryColumnWidth = 415.0f;
    self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    self.viewControllers = @[locationsNavigationController, pickerNavigationController];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - View Setup -

- (void)viewDidLoad {
    [super viewDidLoad];


}


@end
