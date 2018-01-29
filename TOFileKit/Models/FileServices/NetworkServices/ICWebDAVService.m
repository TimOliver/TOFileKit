//
//  ICWebDAVService.m
//  icomics
//
//  Created by Tim Oliver on 27/10/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import "ICWebDAVService.h"
#import "AFWebDAVManager.h"

@interface ICWebDAVService ()

@property (nonatomic, strong) AFWebDAVManager *testManager;

@end

@implementation ICWebDAVService

+ (NSString *)name
{
    return NSLocalizedString(@"WebDAV Server", @"");
}

+ (UIImage *)icon
{
    return [UIImage imageNamed:@"DownloadTableIcon-WebDAV"];
}

+ (NSString *)netServiceType
{
    return @"_webdav._tcp.";
}

- (NSString *)placeholderServerAddress
{
    return @"domain.com";
}

- (NSInteger)defaultPort
{
    return 80;
}

+ (ICDownloadServiceType)serviceType
{
    return ICDownloadServiceTypeWebDAV;
}

- (void)testConnectionWithSuccessHandler:(void (^)(void))successHandler failHandler:(void (^)(NSString *))failHandler
{
    if (self.testManager) {
        return;
    }
    
    self.testManager = [[AFWebDAVManager alloc] initWithBaseURL:[NSURL URLWithString:self.serverAddress]];
    self.testManager.credential = [NSURLCredential credentialWithUser:self.userName
                                                             password:self.password
                                                          persistence:NSURLCredentialPersistenceForSession];
    
    [self.testManager contentsOfDirectoryAtURLString:@"/"
                                        recursive:NO
                                completionHandler:^(NSArray *items, NSError *error)
    {
        if (error) {
            failHandler(error.localizedDescription);
        } else {
            successHandler();
        }
        
        self.testManager = nil;
    }];
}

- (void)stopConnectionTest
{
    [self.testManager.operationQueue cancelAllOperations];
    self.testManager = nil;
}

@end
