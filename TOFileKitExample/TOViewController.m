//
//  TOViewController.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 31/12/17.
//  Copyright © 2017 Tim Oliver. All rights reserved.
//

#import "TOViewController.h"
#import <TODocumentPickerViewController/TODocumentPickerLocalDiskDataSource.h>

#import "TOFileCoordinator.h"

#import "TOFileLocationsViewController.h"
#import "TOFileNavigationController.h"

@interface TOViewController ()

@property (nonatomic, strong) TOFileCoordinator *fileCoordinator;

@end

@implementation TOViewController

- (instancetype)init
{
    if (self = [super initWithConfiguration:[self createPickerConfinguration] filePath:nil]) {
        self.dataSource = [[TODocumentPickerLocalDiskDataSource alloc] initWithBaseFolderPath:@"Documents"];
        _fileCoordinator = [[TOFileCoordinator alloc] init];
    }
    
    return self;
}

- (void)addButtonTapped:(id)sender
{
    
}

- (void)downloadsButtonTapped:(id)sender
{
    TOFileLocationsViewController *accountsController = [[TOFileLocationsViewController alloc] initWithFileCoordinator:_fileCoordinator];
    TOFileNavigationController *navigationController = [[TOFileNavigationController alloc] initWithRootViewController:accountsController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (TODocumentPickerConfiguration *)createPickerConfinguration
{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
    UIBarButtonItem *downloadButton = [[UIBarButtonItem alloc] initWithTitle:@"Downloads" style:UIBarButtonItemStylePlain target:self action:@selector(downloadsButtonTapped:)];
    
    TODocumentPickerConfiguration *configuration = [[TODocumentPickerConfiguration alloc] init];
    configuration.toolbarLeftItems = @[addButton];
    configuration.toolbarRightItems = @[downloadButton];
    
    return configuration;
}

@end
