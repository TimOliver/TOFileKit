//
//  TOFileCoordinatorTests.h
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

/** Test the singleton */
- (void)testFileCoordinatorSingleton
{
    TOFileCoordinator *fileCoordinator1 = [TOFileCoordinator sharedCoordinator];
    TOFileCoordinator *fileCoordinator2 = [TOFileCoordinator sharedCoordinator];
    
    XCTAssertEqual(fileCoordinator1, fileCoordinator2);
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

- (void)testFileCoordinatorStartAndStop
{
    TOFileCoordinator *fileCoordinator = [[TOFileCoordinator alloc] init];
    
    [fileCoordinator start];
    XCTAssertTrue(fileCoordinator.isRunning);
    
    [fileCoordinator stop];
    XCTAssertFalse(fileCoordinator.isRunning);
}

- (void)testFileCoordinatorDealloc
{
    __weak TOFileCoordinator *weakCoordinator;
    @autoreleasepool {
        TOFileCoordinator *weakCoordinator = [[TOFileCoordinator alloc] init];
        XCTAssertNotNil(weakCoordinator);
    }
    XCTAssertNil(weakCoordinator);
}

@end
