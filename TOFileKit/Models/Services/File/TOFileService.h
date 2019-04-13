//
//  TOFileService.h
//
//  Copyright 2015-2019 Timothy Oliver. All rights reserved.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "TOFileConstants.h"

/*******************************************************************************/

NS_ASSUME_NONNULL_BEGIN

@interface TOFileService : NSObject

/* Retrieve the class of the specified service */
+ (Class)classOfServiceForType:(TOFileServiceType)type;

/* Create a new instance based off a specific service */
+ (instancetype)fileServiceForType:(TOFileServiceType)type;

/************************************************************/
/* Convenience Methods to expose the available services. */

/* A dictionary of each service class with its enum value as the key. */
+ (NSDictionary *)allServices;

/* An array of the service classes based on third party file hosting services (Dropbox, etc) */
+ (NSArray *)cloudHostedServices;

/* An array of the service classes based on local network protocol services (SMB, FTP, etc) */
+ (NSArray *)customHostedServices;

/************************************************************/
/* General Information for this service class */

/* The specific type of this service */
+ (TOFileServiceType)serviceType;

/* The name of the service */
+ (NSString *)name;

/* Validates if there is an app on device that can authorize for us. (eg, like Dropbox) */
+ (BOOL)nativeAppServiceAvailable;

/************************************************************/

/* The name that this service will be identfied by. */
@property (nonatomic, copy) NSString *name;

/* The default name for this service if the user doesn't specify one */
@property (nonatomic, readonly) NSString *placeholderName;

/* Common Properties/Methods for all subclasses */
@property (nonatomic, strong) NSString *initialFilePath;

/* Instance version of `serviceType` class method */
@property (nonatomic, readonly) TOFileServiceType serviceType;

/* Given a user name, create a formatted name for this service including it. */
- (NSString *)personalizedNameOfServiceWithUserName:(nullable NSString *)userName;

/************************************************************/

/* Asynchronously performs a test with the credentials */
- (void)testConnectionWithSuccessHandler:(void (^)(void))successHandler failHandler:(void (^)(NSString *))failHandler;

/* Stops an asynchronous test */
- (void)stopConnectionTest;

@end

NS_ASSUME_NONNULL_END
