//
//  ICOAuthDownloadService.h
//  iComics
//
//  Created by Tim Oliver on 31/12/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import "ICDownloadService.h"
#import "NSDictionary+URLEncodedString.h"

@interface ICOAuthDownloadService : ICDownloadService

/* Input Information */
@property (nonatomic, readonly) UIImage *serviceLogo;         //A large version of the service logo
@property (nonatomic, copy, readonly) NSString *CSRFToken;    //A random string to be used to validate callbacks
@property (nonatomic, readonly) BOOL forceMobilePage;         //Force the page to render as a mobile
@property (nonatomic, readonly) BOOL providesCSRFChecking;    //Allows the exchange of a 'state' token to prevent CSRF attacks
@property (nonatomic, readonly) BOOL requiresTokenExchange;   //Requires an additional REST call to convert an auth code into an access token
@property (nonatomic, readonly) BOOL canProvideUserInfo;      //For the purpose of giving it a custom name, whether the API can give the user's name

/** Output Information */
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, strong) NSDate *accessTokenExpirationDate;

/* Input steps for authorization */
- (NSURL *)oauthPageURL;

/* Check the URL pattern to see if it's the one we specified */
- (BOOL)isCallbackURLWithURL:(NSURL *)URL;

/* Where possible, check the nonce to ensure this is our callback URL */
- (BOOL)verifyCallbackURLWithURL:(NSURL *)callbackURL;

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
