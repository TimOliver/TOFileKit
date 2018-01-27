//
//  ICDownloadService.m
//  icomics
//
//  Created by Tim Oliver on 27/10/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import "ICDownloadService.h"

#import "ICDropboxService.h"
#import "ICBoxService.h"
#import "ICOneDriveService.h"
#import "ICGoogleDriveService.h"
#import "ICFTPService.h"
#import "ICSFTPService.h"
#import "ICWebDAVService.h"
#import "ICSMBService.h"

#import "XLForm.h"

NSString * const ICDownloadServiceDidReceiveURLCallback = @"ICDownloadServiceDidReceiveURLCallback";

@implementation ICDownloadService

+ (Class)classOfServiceForType:(ICDownloadServiceType)type
{
    return [[ICDownloadService allServices] objectForKey:@(type)];
}

+ (instancetype)downloadServiceForType:(ICDownloadServiceType)type
{
    Class class = [ICDownloadService classOfServiceForType:type];
    if (class == nil)
        return nil;
    
    return [[class alloc] init];
}

#pragma mark - Listing All Services -
+ (NSDictionary *)allServices
{
    return @{@(ICDownloadServiceTypeDropbox)     : [ICDropboxService class],
             @(ICDownloadServiceTypeGoogleDrive) : [ICGoogleDriveService class],
             @(ICDownloadServiceTypeOneDrive)    : [ICOneDriveService class],
             @(ICDownloadServiceTypeBox)         : [ICBoxService class],
             @(ICDownloadServiceTypeSMB)         : [ICSMBService class],
             @(ICDownloadServiceTypeFTP)         : [ICFTPService class],
             @(ICDownloadServiceTypeSFTP)        : [ICSFTPService class],
             @(ICDownloadServiceTypeWebDAV)      : [ICWebDAVService class]
    };
}

+ (NSArray *)fileHostingServices
{
    return @[[ICDropboxService class], [ICGoogleDriveService class], [ICOneDriveService class], [ICBoxService class]];
}

+ (NSArray *)networkProtocolServices
{
    return @[[ICSMBService class], [ICFTPService class], [ICSFTPService class], [ICWebDAVService class]];
}

- (ICDownloadServiceType)serviceType
{
    return [[self class] serviceType];
}

#pragma mark - Service Name -
- (NSString *)personalizedNameOfServiceWithUserName:(NSString *)userName
{
    NSString *serviceName = [self.class name];
    
    if (userName == nil || userName.length == 0) {
        NSString *localizedNamelessString = NSLocalizedString(@"My %@", @"Nameless Personal Download Name");
        return [NSString stringWithFormat:localizedNamelessString, serviceName];
    }
    
    return [NSString stringWithFormat:NSLocalizedString(@"%@'s %@", @"Personal Download Name"), userName, serviceName];
}

- (NSString *)placeholderName
{
    return [self.class name];
}

- (XLFormDescriptor *)formDescriptorForEditingService { return nil; }

#pragma mark - Subclass Overrides -
+ (ICDownloadServiceType)serviceType { return ICDownloadServiceTypeNone; }
+ (NSString *)name  { return nil; }
+ (UIImage *)icon   { return nil; }
+ (BOOL)nativeAppServiceAvailable { return NO; }
- (void)testConnectionWithSuccessHandler:(void (^)(void))successHandler failHandler:(void (^)(NSString *))failHandler { }
- (void)stopConnectionTest { }

@end

