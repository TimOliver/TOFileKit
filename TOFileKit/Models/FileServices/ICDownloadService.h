//
//  ICDownloadService.h
//  icomics
//
//  Created by Tim Oliver on 27/10/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICDownloadServiceProfile;
@class XLFormDescriptor;
@class XLFormRowDescriptor;

typedef NS_ENUM(NSInteger, ICDownloadServiceType) {
    ICDownloadServiceTypeNone = 0,
    
    //Third Party Services
    ICDownloadServiceTypeDropbox = 1,
    ICDownloadServiceTypeGoogleDrive = 2,
    ICDownloadServiceTypeOneDrive = 3,
    ICDownloadServiceTypeBox = 4,
    
    //Self-hosted Services
    ICDownloadServiceTypeSMB = 11,
    ICDownloadServiceTypeFTP = 12,
    ICDownloadServiceTypeSFTP = 13,
    ICDownloadServiceTypeWebDAV = 14
};

static inline BOOL ICDownloadServiceIsOAuth(ICDownloadServiceType type) {
    return type >= ICDownloadServiceTypeDropbox && type <= ICDownloadServiceTypeBox;
}

static inline BOOL ICDownloadServiceIsProtocol(ICDownloadServiceType type) {
    return type >= ICDownloadServiceTypeSMB && type <= ICDownloadServiceTypeWebDAV;
}

/*******************************************************************************/

@interface ICDownloadService : NSObject

/* Retrieve the class of the specified service */
+ (Class)classOfServiceForType:(ICDownloadServiceType)type;

/* Create a new instance based off a specific service */
+ (instancetype)downloadServiceForType:(ICDownloadServiceType)type;

/************************************************************/
/* Convenience Methods to expose the available services. */

/* A dictionary of each service class with its enum value as the key. */
+ (NSDictionary *)allServices;

/* An array of the service classes based on third party file hosting services (Dropbox, etc) */
+ (NSArray *)fileHostingServices;

/* An array of the service classes based on local network protocol services (SMB, FTP, etc) */
+ (NSArray *)networkProtocolServices;

/************************************************************/
/* General Information for this service */

/* The type of this particular service */
+ (ICDownloadServiceType)serviceType;

/* The name of the service */
+ (NSString *)name;

/* The icon of the service */
+ (UIImage *)icon;

/* Validates if there is an app on device that can authorize for us. */
+ (BOOL)nativeAppServiceAvailable;

/************************************************************/

/* The name that this service will be identfied by. */
@property (nonatomic, copy) NSString *name;

/* The default name for this service if the user doesn't specify one */
@property (nonatomic, readonly) NSString *placeholderName;

/* Common Properties/Methods for all subclasses */
@property (nonatomic, strong) NSString *initialFilePath;

/* Instance version of `serviceType` class method */
@property (nonatomic, readonly) ICDownloadServiceType serviceType;

/* Given a user name, create a formatted name for this service including it. */
- (NSString *)personalizedNameOfServiceWithUserName:(NSString *)userName;

/************************************************************/

/* Builds a form descriptor for editing the parameters of this service */
- (XLFormDescriptor *)formDescriptorForEditingService;

/************************************************************/

/* Asynchronously performs a test with the credentials */
- (void)testConnectionWithSuccessHandler:(void (^)(void))successHandler failHandler:(void (^)(NSString *))failHandler;

/* Stops an asynchronous test */
- (void)stopConnectionTest;

@end