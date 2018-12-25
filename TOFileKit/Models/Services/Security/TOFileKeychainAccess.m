//
//  TOFileKeychainAccess.m
//
//  Copyright 2015-2018 Timothy Oliver. All rights reserved.
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

#import "TOFileKeychainAccess.h"
#import <Security/Security.h>

@interface TOFileKeychainAccess ()

/** The identifier string used to track this entry in the keychain */
@property (nonatomic, copy, readwrite) NSString *identifier;

/** All of the common parameters needed to make queries against the keychain. */
@property (nonatomic, readonly) NSMutableDictionary *queryDictionary;

@end

@implementation TOFileKeychainAccess

#pragma mark - Class Creation -

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    if (self = [super init]) {
        _identifier = identifier;
    }

    return self;
}

#pragma mark - Data Operations -

- (nullable NSData *)dataFromKeychainWithError:(NSError **)error
{
    NSMutableDictionary *query = self.queryDictionary;

    // Try and retrieve the data from the keychain
    NSMutableDictionary *readQuery = query.mutableCopy;
    readQuery[(__bridge id)kSecReturnData] = @YES;

    // Perform the query and return the data if found.
    CFTypeRef dataRef = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)readQuery, &dataRef);
    if (status == errSecSuccess) {
        return (__bridge NSData *)dataRef;
    }

    // If there was no key or an error occurred retrieving it, create a new key and return it

    // Generate a new stream of data
    uint8_t buffer[64];
    status = SecRandomCopyBytes(kSecRandomDefault, 64, buffer);
    NSAssert(status == 0, @"Failed to generate random bytes for key");
    NSData *keyData = [[NSData alloc] initWithBytes:buffer length:sizeof(buffer)];

    // Create the query object for the keychain
    query[(__bridge id)kSecValueData] = keyData;

    status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    NSAssert(status == errSecSuccess, @"Failed to insert new key in the keychain");

    return keyData;
}

- (BOOL)deleteDataFromKeychainWithError:(NSError **)error
{
    NSMutableDictionary *query = self.queryDictionary;
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    return (status == errSecSuccess);
}

- (BOOL)dataExistsInKeychain
{
    // Perform a query to see if the data exists in the keychain
    NSMutableDictionary *query = self.queryDictionary;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    return (status == errSecSuccess);
}

#pragma mark - Keychain Operations -
- (NSMutableDictionary *)queryDictionary
{
    const char *identifierString = [self.identifier cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *identifierTag = [NSData dataWithBytes:(void *)identifierString length:strlen(identifierString)];

    // Create a dictionary object used to query the keychain
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    query[(__bridge id)kSecClass] = (__bridge id)kSecClassKey;
    query[(__bridge id)kSecAttrApplicationTag] = identifierTag;
    query[(__bridge id)kSecAttrKeySizeInBits] = @512;

    return query;
}

@end
