//
//  TOFileCustomService.m
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

#import "TOFileCustomService.h"

NSString * const kICNetworkServiceNameKey           = @"name";
NSString * const kICNetworkServiceServerAddressKey  = @"serverAddress";
NSString * const kICNetworkServicePortNumberKey     = @"portNumber";
NSString * const kICNetworkServiceUserNameKey       = @"userName";
NSString * const kICNetworkServicePasswordKey       = @"password";

@implementation TOFileCustomService

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
