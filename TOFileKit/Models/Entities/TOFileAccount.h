//
//  TOFileAccount.h
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

#import "TOFileConstants.h"

#import <Realm/Realm.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TOFileAccount : RLMObject

/* Base Model Properties */
@property (nonatomic, copy) NSString *uuid;           /** The primary key of this account entry */
@property (nonatomic, assign) TOFileService serviceType; /** The enum value of these accounts */
@property (nonatomic, assign) BOOL temporary;         /** Account is only kept until any downloads assigned to it are complete. */

/* Common Model Properties */
@property (nonatomic, copy) NSString *name;           /** The convenience name of this account */
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

@end

RLM_ARRAY_TYPE(TOFileAccount)

NS_ASSUME_NONNULL_END
