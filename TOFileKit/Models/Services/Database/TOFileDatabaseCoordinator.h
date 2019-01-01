//
//  TOFileDatabaseCoordinator.h
//  TOFileKitExample
//
//  Created by Tim Oliver on 1/1/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A small coordinator object that is used to ensure the Realm database file is created correctly on disk.
 If the file cannot be opened (eg, corrupted, or the encryption key was lost), it will delete and recreate it.
 */
@interface TOFileDatabaseCoordinator : NSObject

/** The database file exists on disk. */
@property (nonatomic, readonly) BOOL fileExists;

/** The file is (or at least is meant to be) encrypted. */
@property (nonatomic, readonly) BOOL encrypted;

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
