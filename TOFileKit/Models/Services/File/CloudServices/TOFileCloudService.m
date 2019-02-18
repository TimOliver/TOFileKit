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

#import "TOFileCloudService.h"

NSString * const kICOAuthRequestCodeKey = @"code";
NSString * const kICOAccessTokenKey = @"access_token";
NSString * const kICOAuthCSRFCodeKey = @"state";

//******************************************************************

@interface TOFileCloudService ()
@property (nonatomic, copy, readwrite) NSString *CSRFToken;
@end

//******************************************************************

@implementation TOFileCloudService

#pragma mark - Base Class Verifications -
- (BOOL)isExpectedCallbackURL:(NSURL *)URL
{
    return [URL.scheme isEqualToString:@""] || [URL.host isEqualToString:@"localhost"];
}

- (BOOL)isValidCallbackURL:(NSURL *)callbackURL
{
    //Sadly, if the service doesn't provide CSRF checking, just assume it passed
    if (self.providesCSRFChecking == NO) {
        return YES;
    }
    
    NSString *code = [self valueForQueryItemWithName:kICOAuthCSRFCodeKey forURL:callbackURL];
    //If it wasn't encoded as a URL query item, see if it was encoded as fragment (Mainly necessary for Dropbox)
    if (code == nil) {
        code = [self valueForFragmentItemWithName:kICOAuthCSRFCodeKey forURL:callbackURL];
    }
    
    //Return if a code was found and it exactly matches
    if (code) {
        return [code isEqualToString:self.CSRFToken];
    }
    
    return NO;
}

#pragma mark - CSRF Token -
- (NSString *)CSRFToken
{
    //Generate an new CSRF string that can be used to verify further responses
    if (_CSRFToken == nil) {
        _CSRFToken = [[NSUUID UUID] UUIDString];
    }
    
    return _CSRFToken;
}

#pragma mark - URL Component Parsing -
- (NSString *)valueForQueryItemWithName:(NSString *)name forURL:(NSURL *)URL
{
    //Loop through each URL component and verify there is a valid CSRF nonce
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    for (NSURLQueryItem *item in components.queryItems) {
        if ([item.name caseInsensitiveCompare:name] == NSOrderedSame) {
            return item.value;
        }
    }
    
    return nil;
}

- (NSString *)valueForFragmentItemWithName:(NSString *)name forURL:(NSURL *)URL
{
    //Loop through each URL component and verify there is a valid CSRF nonce
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    for (NSURLQueryItem *item in components.queryItems) {
        if ([item.name caseInsensitiveCompare:name] == NSOrderedSame) {
            return item.value;
        }
    }
    
    return nil;
}

- (NSString *)accessTokenFromCallbackURL:(NSURL *)callbackURL
{
    return [self valueForQueryItemWithName:kICOAccessTokenKey forURL:callbackURL];
}

#pragma mark - Authentication URL Requests -
- (NSMutableURLRequest *)authenticatedURLRequestWithURLString:(NSString *)URLString accessToken:(NSString *)accessToken
{
    NSURL *URL = [NSURL URLWithString:URLString];
    NSString *authString = [NSString stringWithFormat:@"Bearer %@", accessToken];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    [request setValue:authString forHTTPHeaderField:@"Authorization"];
    return request;
}

#pragma mark - Stub Subclass Methods -

- (NSURL *)authorizationURL { return nil; }
- (NSURLRequest *)URLRequestForAccessTokenConversionWithCallbackURL:(NSURL *)callbackURL { return nil; }
- (NSURLRequest *)URLRequestForUserInfoWithAccessToken:(NSString *)accessToken { return nil; }
- (NSString *)userNameFromUserInfoRequestData:(NSData *)data error:(NSError **)error { return nil; }
- (BOOL)parseAccessCredentialsFromRequestResponseWithData:(NSData *)data { return NO; }
- (BOOL)providesCSRFChecking { return YES; }
- (BOOL)requiresTokenExchange { return YES; }
- (BOOL)canProvideUserInfo { return NO; }

@end
