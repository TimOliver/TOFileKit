//
//  ICNetworkDownloadService.m
//  iComics
//
//  Created by Tim Oliver on 31/12/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import "ICNetworkDownloadService.h"
#import "XLForm.h"

NSString * const kICNetworkServiceNameKey           = @"name";
NSString * const kICNetworkServiceServerAddressKey  = @"serverAddress";
NSString * const kICNetworkServicePortNumberKey     = @"portNumber";
NSString * const kICNetworkServiceUserNameKey       = @"userName";
NSString * const kICNetworkServicePasswordKey       = @"password";

@implementation ICNetworkDownloadService

- (NSString *)placeholderName
{
    return [self personalizedNameOfServiceWithUserName:nil];
}

- (NSString *)placeholderServerAddress
{
    return @"127.0.0.1";
}

+ (NSString *)netServiceType
{
    return nil;
}

- (XLFormDescriptor *)formDescriptorForEditingService
{
    // Import the current theme
    id<ICTheme> theme = [ICThemeManager sharedTheme];
    
    // Create the base form
    XLFormDescriptor *form = [XLFormDescriptor formDescriptor];
    
    // First section
    XLFormSectionDescriptor *credentialsSection = [XLFormSectionDescriptor formSection];
    
    // Create the row entry for the service's convinience name
    XLFormRowDescriptor *nameRow = [XLFormRowDescriptor formRowDescriptorWithTag:kICNetworkServiceNameKey rowType:XLFormRowDescriptorTypeText];
    nameRow.title = NSLocalizedString(@"Name", @"");
    nameRow.value = self.name;
    [ICThemeManager customizeTextFormRowDescriptor:nameRow placeholderString:self.placeholderName forTableType:ICThemeTableViewTypeGroupedSettings];
    [credentialsSection addFormRow:nameRow];
    
    // Create the row entry for the services host name
    XLFormRowDescriptor *serverRow = [XLFormRowDescriptor formRowDescriptorWithTag:kICNetworkServiceServerAddressKey rowType:XLFormRowDescriptorTypeURL];
    serverRow.value = self.serverAddress;
    serverRow.title = NSLocalizedString(@"Server", @"");
    [ICThemeManager customizeTextFormRowDescriptor:serverRow placeholderString:self.placeholderServerAddress forTableType:ICThemeTableViewTypeGroupedSettings];
    [credentialsSection addFormRow:serverRow];
    
    if (self.defaultPort >= 0) {
        XLFormRowDescriptor *portRow = [XLFormRowDescriptor formRowDescriptorWithTag:kICNetworkServicePortNumberKey rowType:XLFormRowDescriptorTypeNumber];
        portRow.value = self.portNumber;
        portRow.title = NSLocalizedString(@"Port", @"");
        [ICThemeManager customizeTextFormRowDescriptor:portRow placeholderString:[@(self.defaultPort) stringValue] forTableType:ICThemeTableViewTypeGroupedSettings];
        [credentialsSection addFormRow:portRow];
    }
    
    NSString *loginPlaceholderString = NSLocalizedString(@"(Optional)", @"");
    
    // Create the user name row object
    XLFormRowDescriptor *usernameRow = [XLFormRowDescriptor formRowDescriptorWithTag:kICNetworkServiceUserNameKey rowType:XLFormRowDescriptorTypeName];
    usernameRow.value = self.userName;
    usernameRow.title = NSLocalizedString(@"User Name", @"");
    [ICThemeManager customizeTextFormRowDescriptor:usernameRow placeholderString:loginPlaceholderString forTableType:ICThemeTableViewTypeGroupedSettings];
    [credentialsSection addFormRow:usernameRow];
    
    //Password row
    XLFormRowDescriptor *passwordRow = [XLFormRowDescriptor formRowDescriptorWithTag:kICNetworkServicePasswordKey rowType:XLFormRowDescriptorTypePassword];
    passwordRow.value = self.password;
    passwordRow.title = NSLocalizedString(@"Password", @"");
    [ICThemeManager customizeTextFormRowDescriptor:passwordRow placeholderString:loginPlaceholderString forTableType:ICThemeTableViewTypeGroupedSettings];
    [credentialsSection addFormRow:passwordRow];
    
    //Add the section to the form
    [form addFormSection:credentialsSection];
    
    return form;
}

- (NSInteger)defaultPort
{
    return -1;
}

@end
