//
//  TOFileCustomServiceFTP.m
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

#import "TOFileCustomServiceFTP.h"
#import "GRRequestsManager.h"
#import "GRListingRequest.h"

@interface TOFileCustomServiceFTP () <GRRequestsManagerDelegate>

@property (nonatomic, strong) GRRequestsManager *ftpManager;
@property (nonatomic, strong) GRRequestsManager *testFTPManager;

@property (nonatomic, copy) void (^testSuccessHandler)(void);
@property (nonatomic, copy) void (^testFailedHandler)(NSString *);

@end

@implementation TOFileCustomServiceFTP

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
