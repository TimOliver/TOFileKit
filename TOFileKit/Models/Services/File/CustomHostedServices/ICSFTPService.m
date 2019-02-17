//
//  ICSFTPService.m
//  icomics
//
//  Created by Tim Oliver on 27/10/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import "ICSFTPService.h"
#import <NMSSH/NMSSH.h>

@interface ICSFTPService ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation ICSFTPService

+ (NSString *)name
{
    return NSLocalizedString(@"SFTP Server", @"");
}

+ (UIImage *)icon
{
    return [UIImage imageNamed:@"DownloadTableIcon-SFTP"];
}

+ (NSString *)netServiceType
{
    return @"_sftp-ssh._tcp.";
}

- (NSString *)placeholderServerAddress
{
    return @"domain.com";
}

- (NSInteger)defaultPort
{
    return 22;
}

+ (ICDownloadServiceType)serviceType
{
    return ICDownloadServiceTypeSFTP;
}

- (void)testConnectionWithSuccessHandler:(void (^)(void))successHandler failHandler:(void (^)(NSString *))failHandler
{
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    __weak typeof(operation) weakOperation = operation;
    
    //Create an operation to test out our SFTP connection
    [operation addExecutionBlock:^{
        
        NMSSHSession *session = [NMSSHSession connectToHost:self.serverAddress port:22 withUsername:self.userName];
        if (weakOperation.cancelled) {
            [session disconnect];
            return;
        }
        
        if (session.connected) {
            [session authenticateByPassword:self.password];
            
            if (weakOperation.cancelled) {
                [session disconnect];
                return;
            }
            
            BOOL success = session.authorized;
            NSString *errorMessage = session.lastError.localizedDescription;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (success && successHandler) {
                    successHandler();
                }
                else if (!success && failHandler) {
                    failHandler(NSLocalizedString(@"Server Authentication Failed", @""));
                }
            }];
        }
        else {
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 if (failHandler) {
                     failHandler(NSLocalizedString(@"Unable to Connect to Server", @""));
                 }
             }];
        }
        
        [session disconnect];
    }];

    [self.operationQueue addOperation:operation];
}

- (void)stopConnectionTest
{
    
}

- (NSOperationQueue *)operationQueue
{
    if (_operationQueue) {
        return _operationQueue;
    }
    
    _operationQueue = [[NSOperationQueue alloc] init];
    _operationQueue.maxConcurrentOperationCount = 1;
    
    return _operationQueue;
}

@end
