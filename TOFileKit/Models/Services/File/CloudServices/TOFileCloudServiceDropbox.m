//
//  TOFileCloudServiceDropbox.m
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

#import "TOFileCloudServiceDropbox.h"

NSString * const kDropboxAppKey = @"";
NSString * const kDropboxAppSecret = @"";
NSString * const kDropboxOauth2CallbackURL = @"icomics://dropbox-oauth/";

NSString * const kDropboxAPIRUL = @"https://api.dropboxapi.com/1/";

@implementation TOFileCloudServiceDropbox

#pragma mark - Service Information -
+ (TOFileServiceType)serviceType
{
    return TOFileCloudServiceTypeDropbox;
}

+ (NSString *)name
{
    return @"Dropbox";
}

+ (UIImage *)icon
{
    return [UIImage imageNamed:@"DownloadTableIcon-Dropbox"];
}

- (UIImage *)serviceLogo
{
    return [UIImage imageNamed:@"DropboxLogo"];
}

- (BOOL)forceMobilePage
{
    return YES;
}

- (BOOL)requiresTokenExchange
{
    return NO;
}

#pragma mark - OAuth Login Steps -
- (NSURL *)oauthPageURL
{
    //Base OAuth 2 URL
    //https://www.dropbox.com/developers-v1/core/docs#oa2-authorize
    NSURLComponents *url = [[NSURLComponents alloc] initWithString:@"https://www.dropbox.com/1/oauth2/authorize"];
    
    //Configure the components
    NSMutableArray<NSURLQueryItem *> *parameters = [NSMutableArray array];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"response_type" value:@"token"]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"client_id" value:kDropboxAppKey]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"state" value:self.CSRFToken]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"force_reapprove" value:@"true"]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"disable_signup" value:@"true"]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"redirect_uri" value:kDropboxOauth2CallbackURL]];
    url.queryItems = parameters;
    
    return url.URL;
}

- (NSURLRequest *)URLRequestForUserInfoWithAccessToken:(NSString *)accessToken
{
    NSString *URLString = [kDropboxAPIRUL stringByAppendingString:@"account/info"];
    return [self authenticatedURLRequestWithURLString:URLString accessToken:accessToken];
}

- (NSString *)accessTokenFromCallbackURL:(NSURL *)callbackURL
{
    return [self valueForFragmentItemWithName:@"access_token" forURL:callbackURL];
}

- (NSString *)userNameFromUserInfoRequestData:(NSData *)data error:(NSError **)error
{
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    if (jsonDictionary == nil) {
        return nil;
    }
    
    return jsonDictionary[@"display_name"];
}

@end
