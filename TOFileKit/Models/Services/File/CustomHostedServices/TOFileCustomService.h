//
//  TOFileCustomService.h
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

#import "TOFileService.h"

extern NSString * const kICNetworkServiceNameKey;
extern NSString * const kICNetworkServiceServerAddressKey;
extern NSString * const kICNetworkServicePortNumberKey;
extern NSString * const kICNetworkServiceUserNameKey;
extern NSString * const kICNetworkServicePasswordKey;

NS_ASSUME_NONNULL_BEGIN

@interface TOFileCustomService : TOFileService

/** Returns the Bonjour type name for this service */
@property (nonatomic, readonly, class) NSString *netServiceType;

/** The properties related to the credentials for this account. */
@property (nonatomic, copy) NSString *serverAddress;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSNumber *portNumber;

/** A placeholder value for the server name */
@property (nonatomic, readonly) NSString *placeholderServerAddress;

/** The default port number for this service (Or -1 if this service doesn't need ports) */
@property (nonatomic, readonly) NSInteger defaultPort;

/** Returns a service class based on its Bonjour service type */
+ (Class)hostedServiceForNetServiceType:(nullable NSString *)serviceType;

@end

NS_ASSUME_NONNULL_END
