//
//  TOFileCloudService.h
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

@interface TOFileCloudService : TOFileService

@property (nonatomic, copy, readonly) NSString *CSRFToken;    // A random string to be used to validate callbacks
@property (nonatomic, readonly) BOOL providesCSRFChecking;    // Allows the exchange of a 'state' token to prevent CSRF attacks
@property (nonatomic, readonly) BOOL requiresTokenExchange;   // Requires an additional REST call to convert an auth code into an access token
@property (nonatomic, readonly) BOOL canProvideUserInfo;      // For the purpose of giving it a custom name, whether the API can give the user's name

/* The URL that will present the OAuth authorization page to the user */
- (NSURL *)authorizationURL;

/* Check the URL pattern to see if it's the one we specified */
- (BOOL)isExpectedCallbackURL:(NSURL *)URL;

/* Where possible, check the nonce to ensure this is our callback URL */
- (BOOL)isValidCallbackURL:(NSURL *)callbackURL;

/* Use the callback URL to request the final acces token */
- (NSURLRequest *)URLRequestForAccessTokenConversionWithCallbackURL:(NSURL *)callbackURL;

/* Create a request for accessing the user's info */
- (NSURLRequest *)URLRequestForUserInfoWithAccessToken:(NSString *)accessToken;

/* Process the response from the server, extract the access token, and update the properties in this object */
- (BOOL)parseAccessCredentialsFromRequestResponseWithData:(NSData *)data error:(NSError **)error;

/* Take the response for an info request and return the user name */
- (NSString *)userNameFromUserInfoRequestData:(NSData *)data error:(NSError **)error;

/*********************************/
/* Convienience Methods for parsing callback URLs */

/* Parse a URL and retrieve the value for an item in the URL query component. */
- (NSString *)valueForQueryItemWithName:(NSString *)name forURL:(NSURL *)URL;

/* Parse a URL and retrieve the value for an item in the URL fragment component. */
- (NSString *)valueForFragmentItemWithName:(NSString *)name forURL:(NSURL *)URL;

/* Return the access token if it's found in the supplied URL */
- (NSString *)accessTokenFromCallbackURL:(NSURL *)callbackURL;

/*********************************/
/* Convienience Methods for generating authenticated API calls */

- (NSMutableURLRequest *)authenticatedURLRequestWithURLString:(NSString *)URLString accessToken:(NSString *)accessToken;

@end
