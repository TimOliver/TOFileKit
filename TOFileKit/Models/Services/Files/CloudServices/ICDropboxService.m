//
//  ICDropboxService.m
//  icomics
//
//  Created by Tim Oliver on 27/10/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import "ICDropboxService.h"

NSString * const kDropboxAppKey = @"";
NSString * const kDropboxAppSecret = @"";
NSString * const kDropboxOauth2CallbackURL = @"icomics://dropbox-oauth/";

NSString * const kDropboxAPIRUL = @"https://api.dropboxapi.com/1/";

@implementation ICDropboxService

#pragma mark - Service Information -
+ (ICDownloadServiceType)serviceType
{
    return ICDownloadServiceTypeDropbox;
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
