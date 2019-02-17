//
//  ICGoogleDriveService.m
//  icomics
//
//  Created by Tim Oliver on 27/10/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import "ICGoogleDriveService.h"

NSString * const kGoogleDriveAppKey = @"";
NSString * const kGoogleDriveAppSecret = @"";
NSString * const kGoogleDriveOauth2CallbackURL = @"http://localhost:9001";

NSString * const kGoogleAPIURL = @"https://www.googleapis.com/oauth2/v1/";

@implementation ICGoogleDriveService

+ (ICDownloadServiceType)serviceType
{
    return ICDownloadServiceTypeGoogleDrive;
}

+ (NSString *)name
{
    return @"Google Drive";
}

+ (UIImage *)icon
{
    return [UIImage imageNamed:@"DownloadTableIcon-GoogleDrive"];
}

- (UIImage *)serviceLogo
{
    return [UIImage imageNamed:@"GoogleDriveLogo"];
}

#pragma mark - OAuth Login Steps -
- (NSURL *)oauthPageURL
{
    //Base OAuth 2 URL
    //https://developers.google.com/identity/protocols/OAuth2InstalledApp
    NSURLComponents *url = [[NSURLComponents alloc] initWithString:@"https://accounts.google.com/o/oauth2/v2/auth"];
    
    //Configure the components
    NSMutableArray<NSURLQueryItem *> *parameters = [NSMutableArray array];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"response_type" value:@"code"]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"client_id" value:kGoogleDriveAppKey]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"scope" value:@"profile https://www.googleapis.com/auth/drive.readonly"]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"state" value:self.CSRFToken]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"redirect_uri" value:kGoogleDriveOauth2CallbackURL]];
    
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
    NSURL *tokenURL = [NSURL URLWithString:@"https://www.googleapis.com/oauth2/v4/token"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:tokenURL];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code"] = [self valueForQueryItemWithName:@"code" forURL:callbackURL];
    parameters[@"grant_type"] = @"authorization_code";
    parameters[@"client_id"] = kGoogleDriveAppKey;
    parameters[@"client_secret"] = kGoogleDriveAppSecret;
    parameters[@"redirect_uri"] = kGoogleDriveOauth2CallbackURL;
    
    NSLog(@"%@", parameters.URLEncodedString);
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
    self.refreshToken = jsonDictionary[@"id_token"];
    
    NSInteger expirationSeconds = [jsonDictionary[@"expires_in"] integerValue];
    self.accessTokenExpirationDate = [NSDate dateWithTimeIntervalSinceNow:expirationSeconds];
    
    return YES;
}

- (NSURLRequest *)URLRequestForUserInfoWithAccessToken:(NSString *)accessToken
{
    NSString *URLString = [kGoogleAPIURL stringByAppendingString:@"userinfo?alt=json"];
    return [self authenticatedURLRequestWithURLString:URLString accessToken:accessToken];
}

- (NSString *)userNameFromUserInfoRequestData:(NSData *)data error:(NSError **)error
{
    if (data == nil) {
        return nil;
    }
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    if (dictionary == nil) {
        return nil;
    }
    
    return dictionary[@"name"];
}

@end
