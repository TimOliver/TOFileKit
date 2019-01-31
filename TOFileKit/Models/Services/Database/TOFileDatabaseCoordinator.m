//
//  TOFileDatabaseCoordinator.m
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

#import "TOFileDatabaseCoordinator.h"
#import "TOFileKeychainAccess.h"

#import "TOF"

@interface TOFileDatabaseCoordinator ()

@property (nonatomic, copy, readwrite) NSURL *fileURL;
@property (nonatomic, assign, readwrite) BOOL fileExists;
@property (nonatomic, assign, readwrite) BOOL encrypted;
@property (nonatomic, copy, readwrite) NSString *keychainIdentifier;

@property (nonatomic, strong) TOFileKeychainAccess *keychainAccess;

@end

@implementation TOFileDatabaseCoordinator

- (instancetype)initWithFileURL:(NSURL *)fileURL keychainIdentifier:(nullable NSString *)keychainIdentifier;
{
    if (self = [super init]) {
        _fileURL = fileURL;
        _keychainIdentifier = keychainIdentifier;

        if (_keychainIdentifier.length) {
            _encrypted = YES;
            _keychainAccess = [[TOFileKeychainAccess alloc] initWithIdentifier:_keychainIdentifier];
        }
    }
    
    return self;
}

- (BOOL)fileExists
{
    return [[NSFileManager defaultManager] fileExistsAtPath:_fileURL.path];
}

@end
