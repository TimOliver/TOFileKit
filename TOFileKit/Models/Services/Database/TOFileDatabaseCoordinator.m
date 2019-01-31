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

#import "TOFileKit.h"

@interface TOFileDatabaseCoordinator ()

@property (nonatomic, copy, readwrite) NSURL *fileURL;
@property (nonatomic, assign, readwrite) BOOL fileExists;
@property (nonatomic, assign, readwrite) BOOL encrypted;
@property (nonatomic, copy, readwrite) NSString *keychainIdentifier;

@property (nonatomic, strong) TOFileKeychainAccess *keychainAccess;

@property (nonatomic, strong, readwrite) RLMRealmConfiguration *realmConfiguration;

@property (nonatomic, readonly) NSData *encryptionKey;

@end

@implementation TOFileDatabaseCoordinator

#pragma mark - Class Creation -

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

#pragma mark - Realm Configuration Accessor

- (RLMRealmConfiguration *)realmConfiguration
{
    // Once we've successfully created a Realm configuration, re-use it after that
    if (_realmConfiguration) { return _realmConfiguration; }

    // Create a new Realm configuration
    _realmConfiguration = [self newRealmConfiguration];

    // Try and create a Realm instance with it to see if any errors occur.
    NSError *error = nil;
    @autoreleasepool {
        [RLMRealm realmWithConfiguration:_realmConfiguration error:&error];
    }

    // If an error occurred, the file is either corrupt, or the encryption key was wrong.
    // Both of those scenarios are irrecoverable. Delete the file.
    if (error) {
        [[NSFileManager defaultManager] removeItemAtURL:self.fileURL error:nil];
    }

    // The file will be recreated next time the configuration is called, so we can just return it.
    return _realmConfiguration;
}

#pragma mark - Configuration Sanity Checker Methods -

- (NSData *)encryptionKey
{
    if (self.keychainAccess == nil) { return nil; }

    NSError *error = nil;
    NSData *encryptionKey = [self.keychainAccess dataFromKeychainWithError:&error];

    // Return if we got an object back and there were no errors
    if (encryptionKey && !error) { return encryptionKey; }

    NSException *exception = [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unable to edit security keychain entry." userInfo:nil];

    // If we were unable to get at a pre-made key because of some error, delete the key so we can regenerate it.
    // If the delete operation fails, something is clearly wrong with this device. Instead of potentially leaking unencrypted data, throw an exception.
    [self.keychainAccess deleteDataFromKeychainWithError:&error];
    if (error) { [exception raise]; }

    // Try to regenerate the key again. If it fails again, throw the same exception
    encryptionKey = [self.keychainAccess dataFromKeychainWithError:&error];
    if (error) { [exception raise]; }

    return encryptionKey;
}

- (RLMRealmConfiguration *)newRealmConfiguration
{
    RLMRealmConfiguration *config = [[RLMRealmConfiguration alloc] init];
    config.fileURL = self.fileURL;
    config.encryptionKey = self.encryptionKey;
    config.objectClasses = @[[TOFileAccount class], [TOFileAccount class], [TOFileDownload class]];
    return config;
}

- (void)validateRealmOnDisk
{
    // No need to validate if the file hasn't been created yet.
    if (!self.fileExists) { return; }
}

#pragma mark - Accessor Methods -

- (BOOL)fileExists
{
    return [[NSFileManager defaultManager] fileExistsAtPath:_fileURL.path];
}

@end
