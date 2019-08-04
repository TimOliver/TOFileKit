//
//  TOFileRootPresenterTests.m
//  TOFileKitTests
//
//  Created by Tim Oliver on 4/8/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TOFileRootPresenter.h"
#import "TOFileCoordinator.h"

@interface TOFileRootPresenterTests : XCTestCase

@end

@implementation TOFileRootPresenterTests

- (void)testPresenterCreation
{
    TOFileCoordinator *fileCoordinator = [[TOFileCoordinator alloc] init];
    TOFileRootPresenter *presenter = [[TOFileRootPresenter alloc] initWithFileCoordinator:fileCoordinator];
    XCTAssertNotNil(presenter);
}

- (void)testSettingInitialView
{
    TOFileCoordinator *fileCoordinator = [[TOFileCoordinator alloc] init];
    TOFileRootPresenter *presenter = [[TOFileRootPresenter alloc] initWithFileCoordinator:fileCoordinator];

    // Should not called in compact mode
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Show called correctly"];
    expectation.inverted = YES;

    presenter.isCompactPresentation = YES;
    presenter.showItemHandler = ^(TOFileViewControllerType type, id object) {
        [expectation fulfill];
    };

    [presenter setInitialItem:TOFileViewControllerTypeAddLocation modelObject:nil];

    [self waitForExpectations:@[expectation] timeout:0.2f];
}

- (void)testSettingNewView
{
    TOFileCoordinator *fileCoordinator = [[TOFileCoordinator alloc] init];
    TOFileRootPresenter *presenter = [[TOFileRootPresenter alloc] initWithFileCoordinator:fileCoordinator];

    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Show called correctly"];
    presenter.showItemHandler = ^(TOFileViewControllerType type, id object) {
        [expectation fulfill];
    };

    [presenter setInitialItem:TOFileViewControllerTypeAddLocation modelObject:nil];

    [self waitForExpectations:@[expectation] timeout:1.0f];
}

@end
