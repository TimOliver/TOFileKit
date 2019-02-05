//
//  TOFileKeychainAccess.h
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

#import "TOFileKit.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A very basic keychain access class that manages saving and retrieving
 an arbitrary 64-byte stream of data used to encrypt the file accounts Realm file.
 */
@interface TOFileKeychainAccess : NSObject

/** The unique identifier under which the data is saved to the keychain.
    This should be reverse TLD order (eg `com.myapp.files.keychain`) */
@property (nonatomic, readonly) NSString *identifier;

/** Performs a query on the keychain to determine if data has already been saved under that identifier. */
@property (nonatomic, readonly) BOOL dataExistsInKeychain;

/**
 Create a new instance of this class using the specified identifier.
 Once created, the identifier cannot be changed.

 @param identifier The identifier string used to track the data in the keychain
 @return A new object instance
 */
- (instancetype)initWithIdentifier:(NSString *)identifier;

/**
 If not already in the keychain, generates a 64-byte stream of randomized data,
 saves it to the keychain, and then returns it here. If an entry was already in the
 keychain, it returns that one.

 @param error A pointer to an error object. This will be non-nil if an error occurs.
 @return The data from the keychain.
 */
- (nullable NSData *)dataFromKeychainWithError:(NSError **)error;

/**
 Deletes the entire entry from the keychain.

 @param error A pointer to an error object that will be filled if an error occured
 @return `YES` if the data didn't exist or was successfully deleted. `NO` if an error occurred.
 */
- (BOOL)deleteDataFromKeychainWithError:(NSError **)error;

/// :nodoc:
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
