//
//  ICAccount.h
//  icomics
//
//  Created by Tim Oliver on 26/10/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import <Realm/Realm.h>

@class ICDownloadService;
@class ICOAuthDownloadService;
@class ICNetworkDownloadService;

@interface TOFileAccount : RLMObject

/* Base Model Properties */
@property (nonatomic, copy) NSString *uuid;           /** The primary key of this account entry */
@property (nonatomic, assign) NSInteger serviceType;  /** The enum value of these accounts */
@property (nonatomic, assign) NSInteger orderedIndex; /** The ordered index this account appears in the list */
@property (nonatomic, assign) BOOL temporary;         /** Account is only kept until any downloads assigned to it are complete. */

/* Common Model Properties */
@property (nonatomic, copy) NSString *name;           /** The convienience name of this account */
@property (nonatomic, copy) NSString *initialPath;    /** The initial file path to start this account at */

/* Network Protocol Properties */
@property (nonatomic, copy) NSString *serverAddress;  /** The IP address / hostname of the server */
@property (nonatomic, copy) NSNumber<RLMInt> *portNumber;   /** Optionally, the port number to connect to the server */
@property (nonatomic, copy) NSString *userName;       /** For authentication purposes, the username of the account */
@property (nonatomic, copy) NSString *password;       /** For authentication purposes, the password of the account */

/* OAuth 2 Properties */
@property (nonatomic, copy) NSString *accessToken;    /** The access token used to make authorized API calls */
@property (nonatomic, copy) NSString *refreshToken;   /** Where necessary, a token that can be used to refresh the access token */
@property (nonatomic, strong) NSDate *accessTokenExpirationDate; /** Where necessary, the date when the access token will expire */

/* Auxilliary Properties not persisted by Realm */
@property (nonatomic, readonly) UIImage *icon;
@property (nonatomic, readonly) Class serviceClass;

/* Realm file for all account objects. */
+ (RLMRealm *)accountsRealm;

/* Create a new object with OAuth credentials */
+ (instancetype)accountWithOAuthDownloadService:(ICOAuthDownloadService *)service;

/* Create a new account object with Download credentials */
+ (instancetype)accountWithNetworkDownloadService:(ICNetworkDownloadService *)service;

- (ICDownloadService *)downloadServiceForAccount;

@end
