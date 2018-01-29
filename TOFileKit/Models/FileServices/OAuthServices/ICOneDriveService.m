//
//  ICOneDriveService.m
//  icomics
//
//  Created by Tim Oliver on 27/10/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import "ICOneDriveService.h"

NSString * const kOneDriveAppKey = @"";
NSString * const kOneDriveClientSecret = @"";
NSString * const kOneDriveOauth2CallbackURL = @"http://localhost:9001";

NSString * const kOneDriveAPIURL = @"https://api.onedrive.com/v1.0/";

@implementation ICOneDriveService

+ (ICDownloadServiceType)serviceType
{
    return ICDownloadServiceTypeOneDrive;
}

+ (NSString *)name
{
    return @"Microsoft OneDrive";
}

+ (UIImage *)icon
{
    return [UIImage imageNamed:@"DownloadTableIcon-OneDrive"];
}

- (BOOL)forceMobilePage
{
    return YES;
}

- (UIImage *)serviceLogo
{
    return [UIImage imageNamed:@"OneDriveLogo"];
}

- (BOOL)providesCSRFChecking
{
    return NO;
}

#pragma mark - OAuth Login Steps -
- (NSURL *)oauthPageURL
{
    //Base OAuth 2 URL
    //https://www.dropbox.com/developers-v1/core/docs#oa2-authorize
    NSURLComponents *url = [[NSURLComponents alloc] initWithString:@"https://login.live.com/oauth20_authorize.srf"];
    
    //Configure the components
    NSMutableArray<NSURLQueryItem *> *parameters = [NSMutableArray array];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"response_type" value:@"code"]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"client_id" value:kOneDriveAppKey]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"scope" value:@"onedrive.readonly"]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"redirect_uri" value:kOneDriveOauth2CallbackURL]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"uiflavor" value:@"WebMobile"]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"display" value:@"ios_phone"]];
    
    url.queryItems = parameters;
    
    return url.URL;
}

- (BOOL)isCallbackURLWithURL:(NSURL *)URL
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    if ([components.host isEqualToString:@"localhost"] == NO) {
        return NO;
    }
    
    if (components.port.integerValue != 9001) {
        return NO;
    }
    
    return YES;
}

- (NSURLRequest *)URLRequestForAccessTokenConversionWithCallbackURL:(NSURL *)callbackURL
{
    NSURL *tokenURL = [NSURL URLWithString:@"https://login.live.com/oauth20_token.srf"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:tokenURL];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code"] = [self valueForQueryItemWithName:@"code" forURL:callbackURL];
    parameters[@"client_id"] = kOneDriveAppKey;
    parameters[@"client_secret"] = kOneDriveClientSecret;
    parameters[@"redirect_uri"] = kOneDriveOauth2CallbackURL;
    parameters[@"grant_type"] = @"authorization_code";
    
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
    NSString *URLString = [kOneDriveAPIURL stringByAppendingString:@"drive"];
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
    
    NSDictionary *owner = dictionary[@"owner"];
    if (owner == nil) {
        return nil;
    }
    
    NSDictionary *user = owner[@"user"];
    if (user == nil) {
        return nil;
    }
    
    return user[@"displayName"];
}

@end
