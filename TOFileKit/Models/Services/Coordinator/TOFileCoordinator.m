//
//  TOFileCoordinator.m
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

#import "TOFileCoordinator.h"
#import "TOFileCoordinator+Private.h"
#import "TOFileService.h"

static TOFileCoordinator *_sharedCoordinator = nil;

@interface TOFileCoordinator ()

@property (nonatomic, assign, readwrite) BOOL isRunning;

@end

@implementation TOFileCoordinator

#pragma mark - Object Creation/Destruction -
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

- (void)dealloc
{
    [self stop];
}

#pragma mark - Static Creation -

+ (instancetype)sharedCoordinator
{
    if (!_sharedCoordinator) {
        void (^newCoordinatorBlock)(void) = ^{
            _sharedCoordinator = [[TOFileCoordinator alloc] init];
        };

        // Since we can't use dispatch_once, ensure the coordinator is
        // created serially on the main queue
        if ([NSThread isMainThread]) {
            newCoordinatorBlock();
        }
        else {
            dispatch_sync(dispatch_get_main_queue(), newCoordinatorBlock);
        }
    }

    return _sharedCoordinator;
}

+ (void)setSharedCoordinator:(TOFileCoordinator *)coordinator
{
    if (_sharedCoordinator) { [_sharedCoordinator stop]; }

    void (^setCoordinatorBlock)(void) = ^{
        _sharedCoordinator = coordinator;
    };

    // Since we can't use dispatch_once, ensure the coordinator is
    // created serially on the main queue
    if ([NSThread isMainThread]) { setCoordinatorBlock(); }
    else { dispatch_sync(dispatch_get_main_queue(), setCoordinatorBlock); }
}

#pragma mark - Operation Running -
- (void)start
{
    if (self.isRunning) { return; }
    
    self.isRunning = YES;
}

- (void)stop
{
    if (self.isRunning == NO) { return; }
    
    self.isRunning = NO;
}

#pragma mark - Private Methods -

- (NSArray<TOFileService *> *)filteredDisallowedServicesArrayWithArray:(NSArray<TOFileService *> *)array
{
    if (!self.disallowedFileServiceTypes || self.disallowedFileServiceTypes.count == 0) { return array; }

    __weak typeof(self) weakSelf = self;
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(TOFileService *service, NSDictionary *bindings) {
        return ([weakSelf.disallowedFileServiceTypes indexOfObject:@(service.serviceType)] != NSNotFound);
    }];
    return [array filteredArrayUsingPredicate:predicate];
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

