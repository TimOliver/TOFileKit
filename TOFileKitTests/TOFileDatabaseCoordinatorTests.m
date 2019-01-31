//
//  TOFileDatabaseCoordinatorTests.m
//  TOFileKitTests
//
//  Created by Tim Oliver on 27/1/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TOFileKit.h"

NSString * const kTOFileDatabaseCoordinatorFileName = @"net.timoliver.files.realm";
NSString * const kTOFileDatabaseCoordinatorKeychainIdentifier = @"net.timoliver.files.test";

@interface TOFileDatabaseCoordinatorTests : XCTestCase

@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) TOFileKeychainAccess *keychainAccess;

@end

@implementation TOFileDatabaseCoordinatorTests

- (void)setUp
{
    NSString *tempFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:kTOFileDatabaseCoordinatorFileName];
    self.fileURL = [NSURL fileURLWithPath:tempFilePath];

    self.keychainAccess = [[TOFileKeychainAccess alloc] initWithIdentifier:kTOFileDatabaseCoordinatorKeychainIdentifier];
}

- (void)tearDown
{
    [[NSFileManager defaultManager] removeItemAtURL:self.fileURL error:nil];
    [self.keychainAccess deleteDataFromKeychainWithError:nil];
}

- (void)testBasicConfigurationCreation
{
    TOFileDatabaseCoordinator *databaseCoordinator = [[TOFileDatabaseCoordinator alloc] initWithFileURL:self.fileURL keychainAccess:self.keychainAccess];
    RLMRealmConfiguration *configuration = databaseCoordinator.realmConfiguration;
    XCTAssertNotNil(configuration);
}

- (void)testCorruptDatabaseFileAlreadyPresent
{
    // Create a text file where the Realm would be created
    [@"XD" writeToURL:self.fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];

    // Create a database object and then get it to try to open the text file.
    TOFileDatabaseCoordinator *databaseCoordinator = [[TOFileDatabaseCoordinator alloc] initWithFileURL:self.fileURL keychainAccess:self.keychainAccess];
    RLMRealmConfiguration *configuration = databaseCoordinator.realmConfiguration;

    // Check the configuration was created
    XCTAssertNotNil(configuration);

    // Check the file was properly deleted
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:self.fileURL.path]);

    // Try and create a Realm there now
    RLMRealm *realm = [RLMRealm realmWithConfiguration:configuration error:nil];
    XCTAssertNotNil(realm);
}

- (void)testIncorrectEncryptionKey
{
    // Create an initial Realm configuration
    @autoreleasepool {
        TOFileDatabaseCoordinator *databaseCoordinator = [[TOFileDatabaseCoordinator alloc] initWithFileURL:self.fileURL keychainAccess:self.keychainAccess];
        RLMRealmConfiguration *configuration = databaseCoordinator.realmConfiguration;
        XCTAssertNotNil(configuration);
    }

    // Delete the key from the keychain (Which will make it get regenerated next time)
    [self.keychainAccess deleteDataFromKeychainWithError:nil];

    // Try and create another Realm configuration object
    TOFileDatabaseCoordinator *databaseCoordinator = [[TOFileDatabaseCoordinator alloc] initWithFileURL:self.fileURL keychainAccess:self.keychainAccess];
    RLMRealmConfiguration *configuration = databaseCoordinator.realmConfiguration;
    XCTAssertNotNil(configuration);

    // Check that the resulting configuration yields a valid Realm
    RLMRealm *realm = [RLMRealm realmWithConfiguration:configuration error:nil];
    XCTAssertNotNil(realm);
}

@end
