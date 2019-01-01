//
//  TOFileCoordinator.h
//  TOFileKitExample
//
//  Created by Tim Oliver on 31/12/18.
//  Copyright © 2018 Tim Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TOFileConstants.h"

@class RLMRealmConfiguration;

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

/** Whether the database is encrypted or not. When encrypted, an arbitrary byte stream is generated and
    saved to the device's secure keychain using the relative path of the file as its key. It is *strongly* recommended
    to leave encryption on in production versions of the app, but may be useful to leave off when debugging. (Default YES)
 */
@property (nonatomic, assign) BOOL encryptDatabase;

/** Once started and the database is successfully created, this Realm configuration object can be used to establish access
    to the files database for any objects who need access to that info (such as the downloads UI).
    */
@property (nonatomic, readonly) RLMRealmConfiguration *databaseConfiguration;

/** Shows whether the file coordinator has been started and is currently running or not. */
@property (nonatomic, readonly) BOOL isRunning;

/** A singleton object for a whole app. */
+ (instancetype)sharedCoordinator;

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
