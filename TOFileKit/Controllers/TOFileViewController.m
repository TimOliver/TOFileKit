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

- (void)viewDidLoad {
    [super viewDidLoad];


}


@end
