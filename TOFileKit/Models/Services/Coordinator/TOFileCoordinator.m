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
    static dispatch_once_t onceToken;
    static TOFileCoordinator *_sharedCoordinator;
    dispatch_once(&onceToken, ^{
        _sharedCoordinator = [[TOFileCoordinator alloc] init];
    });
    
    return _sharedCoordinator;
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

