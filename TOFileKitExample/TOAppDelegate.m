//
//  TOAppDelegate.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 31/12/17.
//  Copyright © 2017 Tim Oliver. All rights reserved.
//

#import "TOAppDelegate.h"
#import "TOViewController.h"

#import <Realm/Realm.h>
#import "TOFileLocation.h"
#import "TOFileLocationList.h"
#import "TOFileDownload.h"

@interface TOAppDelegate ()

@end

@implementation TOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    TOViewController *viewController = [[TOViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];

    // Spawn a Realm file just to test it for now
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.objectClasses = @[TOFileLocation.class, TOFileLocationList.class, TOFileDownload.class];

    NSFileManager *fileManager = NSFileManager.defaultManager;
    [fileManager removeItemAtURL:config.fileURL error:nil];

    RLMRealm *fileRealm = [RLMRealm realmWithConfiguration:config error:nil];
    NSLog(@"%@", fileRealm);

    return YES;
}

@end
