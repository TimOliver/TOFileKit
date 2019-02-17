//
//  ICFTPService.m
//  icomics
//
//  Created by Tim Oliver on 27/10/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import "ICFTPService.h"
#import "GRRequestsManager.h"
#import "GRListingRequest.h"

@interface ICFTPService () <GRRequestsManagerDelegate>

@property (nonatomic, strong) GRRequestsManager *ftpManager;
@property (nonatomic, strong) GRRequestsManager *testFTPManager;

@property (nonatomic, copy) void (^testSuccessHandler)(void);
@property (nonatomic, copy) void (^testFailedHandler)(NSString *);

@end

@implementation ICFTPService

+ (NSString *)name
{
    return NSLocalizedString(@"FTP Server", @"");
}

+ (UIImage *)icon
{
    return [UIImage imageNamed:@"DownloadTableIcon-FTP"];
}

+ (NSString *)netServiceType
{
    return @"_ftp._tcp.";
}

+ (ICDownloadServiceType)serviceType
{
    return ICDownloadServiceTypeFTP;
}

- (NSString *)placeholderServerAddress
{
    return @"ftp.domain.com";
}

- (NSInteger)defaultPort
{
    return 21;
}

#pragma mark - Connection Testing -
- (void)testConnectionWithSuccessHandler:(void (^)(void))successHandler failHandler:(void (^)(NSString *))failHandler
{
    if (self.testFTPManager) {
        return;
    }
    
    self.testFTPManager = [[GRRequestsManager alloc] initWithHostname:self.serverAddress user:self.userName password:self.password];
    self.testFTPManager.delegate = self;
    id<GRRequestProtocol> request = [self.testFTPManager addRequestForListDirectoryAtPath:@"/"];
    request.streamInfo.timeout = 15.0f;
    
    [self.testFTPManager startProcessingRequests];
    
    self.testSuccessHandler = successHandler;
    self.testFailedHandler  = failHandler;
}

- (void)stopConnectionTest
{
    [self.testFTPManager stopAndCancelAllRequests];
    self.testFTPManager = nil;
}

#pragma mark - FTP Delegate Events -
- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompleteListingRequest:(id<GRRequestProtocol>)request listing:(NSArray *)listing
{
    if (requestsManager == self.testFTPManager) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.testSuccessHandler) {
                self.testSuccessHandler();
            }
            self.testFTPManager = nil;
        });
        return;
    }
}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didFailRequest:(id<GRRequestProtocol>)request withError:(NSError *)error
{
    if (requestsManager == self.testFTPManager) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.testFailedHandler) {
                self.testFailedHandler(error.userInfo[@"message"]);
            }
            self.testFTPManager = nil;
        });
        return;
    }
}

@end
