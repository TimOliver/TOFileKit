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

/** The location of the database file that stores user accounts and active downloads.
    The value must be inside the app's sandbox, and end with a filename, suffixed with `.realm`.
    The default value is stored in the 'Application Support' folder with the name `com.bundleidentifier.files.realm`.
    This cannot be changed once `start()` has been called;
 */
@property (nonatomic, copy) NSURL *databaseFileURL;

/** Whether the database is encrypted or not. When encrypted, an arbitrary byte stream is genrated and
    saved to the device's secure keychain using the relative path of the file as its key. It is *strongly* recommended
    to leave encryption on in production versions of the app. (Default YES) */
@property (nonatomic, assign) BOOL encryptDatabase;

/** Once started and the database is created, this Realm configuration object can be used to establish access
    to the files database for any objects who need access to that info (such as the downloads UI)
    */
@property (nonatomic, readonly) RLMRealmConfiguration *databaseConfiguration;

/** A singleton object for a whole app. */
+ (instancetype)sharedCoordinator;

/** Once configuration is complete, call start for the coordinator to begin
    any initial setup (ie, creating the database), and to then resume any downloads.
 */
- (void)start;

@end

NS_ASSUME_NONNULL_END
