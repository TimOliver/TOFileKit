//
//  ICNetworkDownloadService.h
//  iComics
//
//  Created by Tim Oliver on 31/12/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import "ICDownloadService.h"

extern NSString * const kICNetworkServiceNameKey;
extern NSString * const kICNetworkServiceServerAddressKey;
extern NSString * const kICNetworkServicePortNumberKey;
extern NSString * const kICNetworkServiceUserNameKey;
extern NSString * const kICNetworkServicePasswordKey;

@interface ICNetworkDownloadService : ICDownloadService

/* The properties related to the credentials for this account. */
@property (nonatomic, copy) NSString *serverAddress;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSNumber *portNumber;

/* A placeholder value for the server name */
@property (nonatomic, readonly) NSString *placeholderServerAddress;

/* The default port number for this service (Or -1 if this service doesn't need ports) */
@property (nonatomic, readonly) NSInteger defaultPort;

/* Returns the Bonjour type name for this service */
+ (NSString *)netServiceType;

@end
