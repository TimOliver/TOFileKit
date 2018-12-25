//
//  TOFileKeychainAccessTests.m
//
//  Copyright 2015-2018 Timothy Oliver. All rights reserved.
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
#import "TOFileKeychainAccess.h"

NSString * const kTOFileKeychainIdentifier = @"net.timoliver.tofilekit.test";

@interface TOFileKeychainAccess (UnitTests)
+ (void)convertStatus:(OSStatus)status toError:(NSError **)error;
@end

@interface TOFileKeychainAccessTests : XCTestCase
@end

@implementation TOFileKeychainAccessTests

#pragma mark - Set-up and Maintenance -

- (void)setUp { [self deleteKeychainData]; }

- (void)tearDown { [self deleteKeychainData]; }

- (void)deleteKeychainData
{
    TOFileKeychainAccess *keychainAccess = [[TOFileKeychainAccess alloc] initWithIdentifier:kTOFileKeychainIdentifier];
    [keychainAccess deleteDataFromKeychainWithError:nil];
}

#pragma mark - Tests -

- (void)testKeychainAccessCreation
{
    TOFileKeychainAccess *keychainAccess = [[TOFileKeychainAccess alloc] initWithIdentifier:kTOFileKeychainIdentifier];
    XCTAssertNotNil(keychainAccess);
    XCTAssertEqual(keychainAccess.identifier, kTOFileKeychainIdentifier);
}

- (void)testKeychainItemDoesntExist
{
    TOFileKeychainAccess *keychainAccess = [[TOFileKeychainAccess alloc] initWithIdentifier:kTOFileKeychainIdentifier];
    XCTAssertFalse(keychainAccess.dataExistsInKeychain);
}

- (void)testKeychainSavesDataCorrectly
{
    NSError *error = nil;
    TOFileKeychainAccess *keychainAccess = [[TOFileKeychainAccess alloc] initWithIdentifier:kTOFileKeychainIdentifier];
    NSData *keychainData = [keychainAccess dataFromKeychainWithError:&error];
    XCTAssertNotNil(keychainData);
    XCTAssertNil(error);
}

- (void)testKeychainDataRemainsConsistent
{
    NSError *error = nil;
    NSData *firstKeychainData = nil;
    NSData *secondKeychainData = nil;

    @autoreleasepool {
        TOFileKeychainAccess *keychainAccess = [[TOFileKeychainAccess alloc] initWithIdentifier:kTOFileKeychainIdentifier];
        firstKeychainData = [keychainAccess dataFromKeychainWithError:&error];
        XCTAssertNotNil(firstKeychainData);
        XCTAssertNil(error);
    }

    @autoreleasepool {
        TOFileKeychainAccess *keychainAccess = [[TOFileKeychainAccess alloc] initWithIdentifier:kTOFileKeychainIdentifier];
        secondKeychainData = [keychainAccess dataFromKeychainWithError:&error];
        XCTAssertNotNil(secondKeychainData);
        XCTAssertNil(error);
    }

    XCTAssertEqualObjects(firstKeychainData, secondKeychainData);
}

- (void)testDeleteKeychainData
{
    TOFileKeychainAccess *keychainAccess = [[TOFileKeychainAccess alloc] initWithIdentifier:kTOFileKeychainIdentifier];
    NSData *keychainData = [keychainAccess dataFromKeychainWithError:nil];
    XCTAssertNotNil(keychainData);

    [keychainAccess deleteDataFromKeychainWithError:nil];
    XCTAssertFalse(keychainAccess.dataExistsInKeychain);
}

- (void)testErrorHandling
{
    NSError *error = nil;
    [TOFileKeychainAccess convertStatus:errSecBadReq toError:&error];
    XCTAssertNotNil(error);
}

@end
