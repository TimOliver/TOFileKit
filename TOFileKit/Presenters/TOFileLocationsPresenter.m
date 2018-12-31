//
//  TOFileLocationsPresenter.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 31/12/18.
//  Copyright © 2018 Tim Oliver. All rights reserved.
//

#import "TOFileLocationsPresenter.h"

@implementation TOFileLocationsPresenter

#pragma mark - User Interaction -

- (void)toggleEditing
{
    self.editing = !self.editing;
    if (self.isEditingHandler) { self.isEditingHandler(self.editing); }
}

#pragma mark - Table View Configuration -

- (NSInteger)numberOfSections
{
    return 2;
}

- (NSInteger)numberOfRowsForSection:(NSInteger)section
{
    return 1;
}

- (NSString *)titleForSection:(NSInteger)section
{
    if (section == 1) {
        return NSLocalizedString(@"Local Devices", @"File Accounts Title");
    }
    
    return NSLocalizedString(@"Accounts", @"File Accounts Title");
}

@end
