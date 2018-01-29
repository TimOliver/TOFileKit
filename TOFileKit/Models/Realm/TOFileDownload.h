//
//  ICDownload.h
//  icomics
//
//  Created by Tim Oliver on 26/10/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import <Realm/Realm.h>

@class ICAccount;

@interface ICDownload : RLMObject

/** The primary key of this download */
@property (nonatomic, copy) NSString *uuid;

/** The total progress of this downloaded (0-100) */
@property (nonatomic, assign) NSInteger progress;

/** The path of this file on the server it's downloaded from */
@property (nonatomic, copy) NSString *serverFilePath;

/** The parent account of this download */
@property (nonatomic, readonly) NSString *accountUUID;

@end
