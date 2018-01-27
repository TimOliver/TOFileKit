//
//  ICOAuthDownloadService.m
//  iComics
//
//  Created by Tim Oliver on 31/12/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import "ICOAuthDownloadService.h"
#import "NSURLComponents+FragmentItems.h"

#import "XLForm.h"

NSString * const kICOAuthAppScheme = @"icomics";
NSString * const kICOAuthRequestCodeKey = @"code";
NSString * const kICOAccessTokenKey = @"access_token";
NSString * const kICOAuthCSRFCodeKey = @"state";

NSString * const kICOAuthServiceNameKey = @"name";

//******************************************************************

@interface ICOAuthDownloadService ()
@property (nonatomic, copy, readwrite) NSString *CSRFToken;
@end

//******************************************************************

@implementation ICOAuthDownloadService

#pragma mark - Base Class Verifications -
- (BOOL)isCallbackURLWithURL:(NSURL *)callbackURL
{
    return [callbackURL.scheme isEqualToString:kICOAuthAppScheme] || [callbackURL.host isEqualToString:@"localhost"];
}

- (BOOL)verifyCallbackURLWithURL:(NSURL *)callbackURL
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
    //Generate an new CSRF string that 
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
    for (NSURLQueryItem *item in components.fragmentItems) {
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
- (NSURL *)oauthPageURL
{
    return nil;
}

- (NSURLRequest *)URLRequestForAccessTokenConversionWithCallbackURL:(NSURL *)callbackURL
{
    return nil;
}

- (NSURLRequest *)URLRequestForUserInfoWithAccessToken:(NSString *)accessToken
{
    return nil;
}

- (NSString *)userNameFromUserInfoRequestData:(NSData *)data error:(NSError **)error
{
    return nil;
}

- (BOOL)parseAccessCredentialsFromRequestResponseWithData:(NSData *)data
{
    return NO;
}

- (BOOL)providesCSRFChecking
{
    return YES;
}

- (BOOL)requiresTokenExchange
{
    return YES;
}

- (BOOL)canProvideUserInfo
{
    return NO;
}

#pragma mark - Form Editing -
- (XLFormDescriptor *)formDescriptorForEditingService
{
    XLFormDescriptor *form = [XLFormDescriptor formDescriptor];
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"ACCOUNT NAME", @"Account Name")];

    id<ICTheme> theme = [ICThemeManager sharedTheme];
    XLFormRowDescriptor *nameRow = [XLFormRowDescriptor formRowDescriptorWithTag:kICOAuthServiceNameKey rowType:XLFormRowDescriptorTypeText];
    [nameRow.cellConfig setObject:[UIColor whiteColor] forKey:@"textField.textColor"];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[theme placeholderTextColorForTextFieldOfType:ICThemeTextFieldTypeSettingsTableView]};
    NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:[self.class name] attributes:attributes];
    [nameRow.cellConfig setObject:placeholder forKey:@"textField.attributedPlaceholder"];
    
    nameRow.value = self.name;
    [section addFormRow:nameRow];
    
    [form addFormSection:section];
    
    return form;
}


@end
