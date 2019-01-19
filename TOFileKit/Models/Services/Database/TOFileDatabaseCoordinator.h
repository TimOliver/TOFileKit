//
//  TOFileDatabaseCoordinator.h
//
//  Copyright 2019 Timothy Oliver. All rights reserved.
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

#import <Foundation/Foundation.h>

@class RLMRealmConfiguration;

NS_ASSUME_NONNULL_BEGIN

/**
 A small coordinator object that is used to ensure the Realm database file is created correctly on disk.
 If the file cannot be opened (eg, corrupted, or the encryption key was lost), it will delete and recreate it.
 */
@interface TOFileDatabaseCoordinator : NSObject

/** The location of the database file on disk */
@property (nonatomic, readonly) NSURL *fileURL;

/** The database file exists on disk. */
@property (nonatomic, readonly) BOOL fileExists;

/** The file is (or at least is meant to be) encrypted. */
@property (nonatomic, readonly) BOOL encrypted;

/** The configuration object that can be used to create thread-specific instances of this database */
@property (nonatomic, readonly) RLMRealmConfiguration *realmConfiguration;

/**
 Create a new instance of the database coordinator, with the location on disk, and
 whether the file is expected to be encrypted.

 @param fileURL The location of the file on disk, including the file name.
 @param encrypted Whether the file is to be encrypted or not.
 @return A new coordinator instance
 */
- (instancetype)initWithFileURL:(NSURL *)fileURL encrypted:(BOOL)encrypted;

@end

NS_ASSUME_NONNULL_END
