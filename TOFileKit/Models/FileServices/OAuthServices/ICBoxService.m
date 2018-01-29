//
//  ICBoxService.m
//  icomics
//
//  Created by Tim Oliver on 27/10/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import "ICBoxService.h"

NSString * const kBoxAppKey = @"";
NSString * const kBoxClientSecret = @"";
NSString * const kBoxOauth2CallbackURL = @"icomics://box-oauth";

NSString * kBoxAPIURL = @"https://api.box.com/2.0/";

@implementation ICBoxService

+ (ICDownloadServiceType)serviceType
{
    return ICDownloadServiceTypeBox;
}

+ (NSString *)name
{
    return @"Box";
}

+ (UIImage *)icon
{
    return [UIImage imageNamed:@"DownloadTableIcon-Box"];
}

- (UIImage *)serviceLogo
{
    return [UIImage imageNamed:@"BoxLogo"];
}

#pragma mark - OAuth Login Steps -
- (NSURL *)oauthPageURL
{
    //Base OAuth 2 URL
    //https://www.dropbox.com/developers-v1/core/docs#oa2-authorize
    NSURLComponents *url = [[NSURLComponents alloc] initWithString:@"https://app.box.com/api/oauth2/authorize"];
    
    //Configure the components
    NSMutableArray<NSURLQueryItem *> *parameters = [NSMutableArray array];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"response_type" value:@"code"]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"client_id" value:kBoxAppKey]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"state" value:self.CSRFToken]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"redirect_uri" value:kBoxOauth2CallbackURL]];
    
    url.queryItems = parameters;
    
    return url.URL;
}

- (BOOL)isCallbackURLWithURL:(NSURL *)URL
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    if ([components.host isEqualToString:@"box-oauth"] == NO) {
        return NO;
    }
    
    return YES;
}

- (NSURLRequest *)URLRequestForAccessTokenConversionWithCallbackURL:(NSURL *)callbackURL
{
    NSURL *tokenURL = [NSURL URLWithString:@"https://app.box.com/api/oauth2/token"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:tokenURL];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code"] = [self valueForQueryItemWithName:@"code" forURL:callbackURL];
    parameters[@"grant_type"] = @"authorization_code";
    parameters[@"client_id"] = kBoxAppKey;
    parameters[@"client_secret"] = kBoxClientSecret;
    parameters[@"redirect_uri"] = kBoxOauth2CallbackURL;

    request.HTTPMethod = @"POST";
    request.HTTPBody = [parameters.URLEncodedString dataUsingEncoding:NSUTF8StringEncoding];
    
    return request;
}

- (BOOL)parseAccessCredentialsFromRequestResponseWithData:(NSData *)data error:(NSError **)error
{
    NSError *_error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&_error];
    if (jsonDictionary == nil || _error) {
        *error = _error;
        return NO;
    }
    
    self.accessToken = jsonDictionary[@"access_token"];
    self.refreshToken = jsonDictionary[@"refresh_token"];
    
    NSInteger expirationSeconds = [jsonDictionary[@"expires_in"] integerValue];
    self.accessTokenExpirationDate = [NSDate dateWithTimeIntervalSinceNow:expirationSeconds];
    
    return YES;
}

- (NSURLRequest *)URLRequestForUserInfoWithAccessToken:(NSString *)accessToken
{
    NSString *URLString = [kBoxAPIURL stringByAppendingString:@"users/me"];
    return [self authenticatedURLRequestWithURLString:URLString accessToken:accessToken];
}

- (NSString *)userNameFromUserInfoRequestData:(NSData *)data error:(NSError *__autoreleasing *)error
{
    if (data == nil) {
        return nil;
    }
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    if (dictionary == nil || error) {
        return nil;
    }
    
    return dictionary[@"name"];
}

@end
