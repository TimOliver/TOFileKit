//
//  TOFileService.m
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

#import "TOFileService.h"

@implementation TOFileService

+ (Class)classOfServiceForType:(TOFileServiceType)type
{
    return [[TOFileService allServices] objectForKey:@(type)];
}

+ (instancetype)fileServiceForType:(TOFileServiceType)type
{
    Class class = [TOFileService classOfServiceForType:type];
    if (class == nil) {
        return nil;
    }
    
    return [[class alloc] init];
}

#pragma mark - Listing All Services -
+ (NSDictionary *)allServices
{
    return @{};
    //    return @{@(ICDownloadServiceTypeDropbox)     : [ICDropboxService class],
//             @(ICDownloadServiceTypeGoogleDrive) : [ICGoogleDriveService class],
//             @(ICDownloadServiceTypeOneDrive)    : [ICOneDriveService class],
//             @(ICDownloadServiceTypeBox)         : [ICBoxService class],
//             @(ICDownloadServiceTypeSMB)         : [ICSMBService class],
//             @(ICDownloadServiceTypeFTP)         : [ICFTPService class],
//             @(ICDownloadServiceTypeSFTP)        : [ICSFTPService class],
//             @(ICDownloadServiceTypeWebDAV)      : [ICWebDAVService class]
//    };
}

+ (NSArray *)fileHostingServices
{
    return @[];
    //return @[[ICDropboxService class], [ICGoogleDriveService class], [ICOneDriveService class], [ICBoxService class]];
}

+ (NSArray *)networkProtocolServices
{
    return @[];
    //return @[[ICSMBService class], [ICFTPService class], [ICSFTPService class], [ICWebDAVService class]];
}

- (TOFileServiceType)serviceType
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

#pragma mark - Subclass Overrides -
+ (TOFileServiceType)serviceType { return TOFileServiceTypeNone; }
+ (NSString *)name  { return nil; }
+ (UIImage *)icon   { return nil; }
+ (BOOL)nativeAppServiceAvailable { return NO; }
- (void)testConnectionWithSuccessHandler:(void (^)(void))successHandler failHandler:(void (^)(NSString *))failHandler { }
- (void)stopConnectionTest { }

@end

