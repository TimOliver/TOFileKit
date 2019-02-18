//
//  TOFileCustomServiceSMB.m
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

#import "TOFileCustomServiceSMB.h"
#import <TOSMBClient/TOSMBClient.h>
#import "NSString+ValidIPAddress.h"

@interface ICSMBService ()

@property (nonatomic, strong) TOSMBSession *testSession;

@end

@implementation ICSMBService

+ (NSString *)name
{
    return NSLocalizedString(@"SMB Server", @"");
}

+ (UIImage *)icon
{
    return [UIImage imageNamed:@"DownloadTableIcon-SMB"];
}

+ (NSString *)netServiceType
{
    return @"_smb._tcp.";
}

- (NSString *)placeholderServerAddress
{
    return @"HostName";
}

+ (ICDownloadServiceType)serviceType
{
    return ICDownloadServiceTypeSMB;
}

- (void)testConnectionWithSuccessHandler:(void (^)(void))successHandler failHandler:(void (^)(NSString *))failHandler
{
    if (self.testSession) {
        return;
    }
    
    //Set up the session
    self.testSession = [[TOSMBSession alloc] init];
    if ([self.serverAddress isValidIPAddress]) {
        self.testSession.ipAddress = self.serverAddress;
    }
    else {
        self.testSession.hostName = self.serverAddress;
    }
    
    //Input credentials
    [self.testSession setLoginCredentialsWithUserName:self.userName password:self.password];
    
    //Perform a basic test
    __weak typeof(self) weakSelf = self;
    [self.testSession requestContentsOfDirectoryAtFilePath:@"/" success:^(NSArray *contents) {
        successHandler();
        weakSelf.testSession = nil;
    }error:^(NSError *error) {
        failHandler(error.localizedDescription);
        weakSelf.testSession = nil;
    }];
}

- (void)stopConnectionTest
{
    [self.testSession cancelAllRequests];
    self.testSession = nil;
}

@end
