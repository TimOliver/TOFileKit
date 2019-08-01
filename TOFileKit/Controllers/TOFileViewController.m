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
#import "TOFileRootPresenter.h"

#import "UIViewController+TOFileRouting.h"

@interface TOFileViewController () <UISplitViewControllerDelegate>

@property (nonatomic, strong) UINavigationController *locationsNavigationController;
@property (nonatomic, strong) TOFileLocationsViewController *locationsViewController;

@property (nonatomic, strong) UINavigationController *locationPickerNavigationController;
@property (nonatomic, strong) TOFileLocationPickerViewController *locationPickerViewController;

@property (nonatomic, strong, readwrite) TOFileCoordinator *fileCoordinator;
@property (nonatomic, strong) TOFileRootPresenter *presenter;

@end

@implementation TOFileViewController

#pragma mark - Class Creation -

- (instancetype)initWithFileCoordinator:(TOFileCoordinator *)fileCoordinator
{
    if (self = [super init]) {
        _fileCoordinator = fileCoordinator;
        _presenter = [[TOFileRootPresenter alloc] initWithFileCoordinator:_fileCoordinator];

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
    // Far left column, the locations view controller
    self.locationsViewController = [[TOFileLocationsViewController alloc] initWithFileCoordinator:_fileCoordinator];
    self.locationsNavigationController = [[TOFileNavigationController alloc] initWithRootViewController:self.locationsViewController];

    // Middle column, by default the picker view controller
    self.locationPickerViewController = [[TOFileLocationPickerViewController alloc] initWithFileCoordinator:_fileCoordinator];
    self.locationPickerNavigationController = [[TOFileNavigationController alloc] initWithRootViewController:self.locationPickerViewController];

    // Configure our split view controller to host these controllers
    self.preferredPrimaryColumnWidthFraction = 0.35f;
    self.minimumPrimaryColumnWidth = 320.0f;
    self.maximumPrimaryColumnWidth = 415.0f;
    self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    self.delegate = self;
    self.viewControllers = @[self.locationsNavigationController, self.locationPickerNavigationController];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Split View Controller Delegate -

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
            collapseSecondaryViewController:(UIViewController *)secondaryViewController
                ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return YES;
}

#pragma mark - View Routing -

- (void)to_showViewControllerOfType:(TOFileViewControllerType)type withObject:(id)object
{
    
}

@end
