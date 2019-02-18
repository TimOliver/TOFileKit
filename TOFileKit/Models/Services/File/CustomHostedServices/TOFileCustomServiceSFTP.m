//
//  TOFileCustomServiceSFTP.h
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

#import "TOFileCustomServiceSFTP.h"
#import <NMSSH/NMSSH.h>

@interface TOFileCustomServiceSFTP ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation TOFileCustomServiceSFTP

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
