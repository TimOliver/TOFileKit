//
//  TOFileCoordinator.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 31/12/18.
//  Copyright © 2018 Tim Oliver. All rights reserved.
//

#import "TOFileCoordinator.h"

@implementation TOFileCoordinator

#pragma mark - Init -
- (instancetype)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    self.databaseFileName = nil;
    self.databaseFolderURL = nil;
    self.temporaryDownloadsFolderURL = nil;
}

#pragma mark - Static Creation -

+ (instancetype)sharedCoordinator
{
    static dispatch_once_t onceToken;
    static TOFileCoordinator *_sharedCoordinator;
    dispatch_once(&onceToken, ^{
        _sharedCoordinator = [[TOFileCoordinator alloc] init];
    });
    
    return _sharedCoordinator;
}

#pragma mark - Operation -
- (void)start
{
    
}

#pragma mark - Accessors -

- (void)setDatabaseFolderURL:(NSURL *)databaseFolderURL
{
    if (_databaseFolderURL && databaseFolderURL == _databaseFolderURL) { return; }
    _databaseFolderURL = databaseFolderURL;
    
    if (_databaseFolderURL != nil) { return; }
    
    // By default, set the folder to application path
    NSString *applicationSupportPath = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject;
    _databaseFolderURL = [NSURL fileURLWithPath:applicationSupportPath];
}

- (void)setDatabaseFileName:(NSString *)databaseFileName
{
    if (_databaseFileName && databaseFileName == _databaseFileName) { return; }
    _databaseFileName = databaseFileName;
    
    if (_databaseFileName != nil) { return; }
    
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    _databaseFileName = [NSString stringWithFormat:@"%@.files.realm", identifier];
}

- (void)setTemporaryDownloadsFolderURL:(NSURL *)temporaryDownloadsFolderURL
{
    if (_temporaryDownloadsFolderURL && _temporaryDownloadsFolderURL == temporaryDownloadsFolderURL) { return; }
    _temporaryDownloadsFolderURL = temporaryDownloadsFolderURL;
    
    if (_temporaryDownloadsFolderURL != nil) { return; }
    
    _temporaryDownloadsFolderURL = [NSURL fileURLWithPath:NSTemporaryDirectory()];
}

@end

