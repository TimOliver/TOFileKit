//
//  TOFileCoordinator.h
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

#import "TOFileKit.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The file coordinator serves as the main source of truth for
 managing files as they are queued up and downloaded. It may
 be used as a global singleton, or as separate instances as needed
 */
@interface TOFileCoordinator : NSObject

/** The folder of the database file that stores user accounts and active downloads.
    The default value is the 'Application Support' folder of the application sandbox.
    This cannot be changed once `start()` has been called.
 */
@property (nonatomic, copy, null_resettable) NSURL *databaseFolderURL;

/** The name on disk of the Realm database file containing all of the user accounts and active downloads.
    The default value is the app bundle identifier suffixed with `.files.realm` (eg. `com.app.myapp.files.realm`)
    This cannot be changed once `start()` has been called.
 */
@property (nonatomic, copy, null_resettable) NSString *databaseFileName;

/**
    The path to the folder that will temporarily buffer the downloading files until they're complete.
    By default, this is the `tmp` folder of your application's sandbox.
    This cannot be changed once `start()` has been called.
 */
@property (nonatomic, copy, null_resettable) NSURL *temporaryDownloadsFolderURL;

/**
 If the database is to be encrypted, this string will be the name under which the encryption
 key for the database is stored. If `nil`, the database won't be encrypted.
 (Default is `nil` for debug builds, and `com.appbundle.identifier.files` for release builds)
 */
@property (nonatomic, copy, nullable) NSString *encryptionKeyIdentifier;

/** Once started and the database is successfully created, this Realm configuration object can be used to establish access
    to the files database for any objects who need access to that info (such as the downloads UI).
    */
@property (nonatomic, readonly) RLMRealmConfiguration *databaseConfiguration;

/** Shows whether the file coordinator has been started and is currently running or not. */
@property (nonatomic, readonly) BOOL isRunning;

/** A singleton object for a whole app. */
+ (instancetype)sharedCoordinator;

/** Set a custom configured file coordinator to be the singleton for this app. This must be set before `start()` is called. */
+ (void)setSharedCoordinator:(TOFileCoordinator *)coordinator;

/** Once configuration is complete, call start for the coordinator to begin
    any initial setup (ie, creating the database), and to then resume any downloads.
 */
- (void)start;

/**
    Stops the file coordinator and suspends/releases all active resources.
    This will be called automatically if the object is deallocated.
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
