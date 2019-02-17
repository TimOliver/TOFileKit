//
//  ICSMBService.m
//  icomics
//
//  Created by Tim Oliver on 27/10/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import "ICSMBService.h"
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
