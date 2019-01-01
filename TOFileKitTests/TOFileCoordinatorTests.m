//
//  TOFileCoordinatorTests.m
//  TOFileKitTests
//
//  Created by Tim Oliver on 1/1/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TOFileCoordinator.h"

@interface TOFileCoordinatorTests : XCTestCase
@end

@implementation TOFileCoordinatorTests

/** Test the file properties are properly populated on launch */
- (void)testFileCoordinatorPathPropertyCreation {
    TOFileCoordinator *fileCoordinator = [[TOFileCoordinator alloc] init];
    XCTAssertNotNil(fileCoordinator.databaseFileName);
    XCTAssertNotNil(fileCoordinator.databaseFolderURL);
    XCTAssertNotNil(fileCoordinator.temporaryDownloadsFolderURL);
}

/** Test explicitly setting the properties to nil resets their values */
- (void)testFileCoordinatorPathPropertyNullResettable
{
    TOFileCoordinator *fileCoordinator = [[TOFileCoordinator alloc] init];
    
    fileCoordinator.databaseFileName = nil;
    XCTAssertNotNil(fileCoordinator.databaseFileName);
    
    fileCoordinator.databaseFolderURL = nil;
    XCTAssertNotNil(fileCoordinator.databaseFolderURL);
    
    fileCoordinator.temporaryDownloadsFolderURL = nil;
    XCTAssertNotNil(fileCoordinator.temporaryDownloadsFolderURL);
}

/** Test the default properties are what we expect. */
- (void)testFileCoordinatorPathPropertyDefaultValues
{
    TOFileCoordinator *fileCoordinator = [[TOFileCoordinator alloc] init];
    
    // Test database location
    NSString *applicationSupportPath = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject;
    XCTAssertEqualObjects(fileCoordinator.databaseFolderURL, [NSURL fileURLWithPath:applicationSupportPath]);

    // Test file name
    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
    NSString *databaseFileName = [NSString stringWithFormat:@"%@.files.realm", bundleIdentifier];
    XCTAssertEqualObjects(fileCoordinator.databaseFileName, databaseFileName);
    
    // Test temp location
    NSURL *tempLocation = [NSURL fileURLWithPath:NSTemporaryDirectory()];
    XCTAssertEqualObjects(fileCoordinator.temporaryDownloadsFolderURL, tempLocation);
}

@end
