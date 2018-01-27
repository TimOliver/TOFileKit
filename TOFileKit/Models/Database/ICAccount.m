//
//  ICAccount.m
//  icomics
//
//  Created by Tim Oliver on 26/10/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import "ICAccount.h"

#import "ICDownloadService.h"
#import "ICOAuthDownloadService.h"
#import "ICNetworkDownloadService.h"

#import "UICKeyChainStore.h"
#import "NSFileManager+DirectoryPaths.h"

NSString * const kICAccountFileName          = @"iComicsAccounts.realm";
NSString * const kICAccountKeychainContainer = @"com.timoliver.icomics";
NSString * const kICAccountKeychainKey       = @"account-token";

@interface ICAccount ()

+ (RLMRealmConfiguration *)accountRealmConfiguration;
+ (NSURL *)accountRealmFileURL;
+ (NSData *)encryptionKey;

@end

@implementation ICAccount

#pragma mark - Object Creation -
+ (instancetype)accountWithOAuthDownloadService:(ICOAuthDownloadService *)service
{
    ICAccount *account = [[ICAccount alloc] init];
    
    account.name = service.name;
    account.accessToken = service.accessToken;
    account.refreshToken = service.refreshToken;
    account.accessTokenExpirationDate = service.accessTokenExpirationDate;
    account.serviceType = service.serviceType;
    account.orderedIndex = [ICAccount allObjectsInRealm:[ICAccount accountsRealm]].count;
    
    return account;
}

+ (instancetype)accountWithNetworkDownloadService:(ICNetworkDownloadService *)service
{
    ICAccount *account = [[ICAccount alloc] init];
    account.name = service.name;
    account.userName = service.userName;
    account.password = service.password;
    account.serverAddress = service.serverAddress;
    account.portNumber = service.portNumber;
    account.serviceType = service.serviceType;
    account.orderedIndex = [ICAccount allObjectsInRealm:[ICAccount accountsRealm]].count;
    
    return account;
}

- (ICDownloadService *)downloadServiceForAccount
{
    ICDownloadService *service = [[self.serviceClass alloc] init];
    
    //Common properties
    service.name = self.name;
    service.initialFilePath = self.initialPath;

    if (ICDownloadServiceIsOAuth(service.serviceType)) {
        ICOAuthDownloadService *oauthService = (ICOAuthDownloadService *)service;
        oauthService.accessToken        = self.accessToken;
        oauthService.refreshToken       = self.refreshToken;
        oauthService.accessTokenExpirationDate = self.accessTokenExpirationDate;
    }
    else {
        ICNetworkDownloadService *downloadService = (ICNetworkDownloadService *)service;
        downloadService.serverAddress = self.serverAddress;
        downloadService.portNumber = self.portNumber;
        downloadService.userName = self.userName;
        downloadService.password = self.password;
    }
    
    return service;
}

#pragma mark - Realm File Management -
+ (RLMRealm *)accountsRealm
{
    NSError *error = nil;
    RLMRealmConfiguration *configuration = [ICAccount accountRealmConfiguration];
    RLMRealm *realm = [RLMRealm realmWithConfiguration:configuration error:&error];
    if (error) {
        //If there's an error, assume the Realm file is compromised and delete it.
        [[NSFileManager defaultManager] removeItemAtPath:configuration.fileURL.path error:nil];
        realm = [RLMRealm realmWithConfiguration:configuration error:&error];
    }
    
    return realm;
}

+ (NSURL *)accountRealmFileURL
{
    return [[NSFileManager applicationSupportDirectoryURL] URLByAppendingPathComponent:kICAccountFileName];
}

+ (RLMRealmConfiguration *)accountRealmConfiguration
{
    static RLMRealmConfiguration *_accountRealmConfiguration;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _accountRealmConfiguration = [[RLMRealmConfiguration alloc] init];
        _accountRealmConfiguration.fileURL = [ICAccount accountRealmFileURL];
        _accountRealmConfiguration.objectClasses = @[[ICAccount class]];
#if TARGET_IPHONE_SIMULATOR
#else
        _accountRealmConfiguration.encryptionKey = [self encryptionKey];
#endif
    });
    
    return _accountRealmConfiguration;
}

+ (NSData *)encryptionKey
{
    //Check the keychain for an existing key
    UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStoreWithService:kICAccountKeychainContainer];
    NSData *encryptionKey = [keychainStore dataForKey:kICAccountKeychainKey];
    if (encryptionKey) {
        return encryptionKey;
    }
    
    // No pre-existing key from this application, so generate a new one, and save it to the keychain
    uint8_t buffer[64];
    SecRandomCopyBytes(kSecRandomDefault, 64, buffer);
    NSData *keyData = [[NSData alloc] initWithBytes:buffer length:sizeof(buffer)];
    [keychainStore setData:keyData forKey:kICAccountKeychainKey];
    
    return keyData;
}

#pragma mark - Auxillary Object Management -
- (UIImage *)icon
{
    Class service = [ICDownloadService classOfServiceForType:self.serviceType];
    if (service == nil) {
        return nil;
    }
    
    return [service icon];
}

- (Class)serviceClass
{
    return [ICDownloadService classOfServiceForType:self.serviceType];
}

#pragma mark - Realm Setup -
+ (NSString *)primaryKey
{
    return @"uuid";
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"uuid" : [[NSUUID UUID] UUIDString] };
}

+ (NSArray *)ignoredProperties
{
    return @[@"icon", @"serviceClass"];
}

@end
