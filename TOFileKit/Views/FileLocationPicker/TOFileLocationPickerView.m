//
//  TOFileLocationPickerView.m
//  TOFileKitExample
//
//  Created by Tim Oliver on 30/6/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "TOFileLocationPickerView.h"
#import "TORoundedTableView.h"
#import "TOFileTableTitleHeaderView.h"
#import "TOFileUtilities.h"

@interface TOFileLocationPickerView ()

@property (nonatomic, strong, readwrite) TORoundedTableView *tableView;
@property (nonatomic, strong) TOFileTableTitleHeaderView *headerView;

@end

@implementation TOFileLocationPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit
{
    // Create the table view
    self.tableView = [[TORoundedTableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    [self addSubview:self.tableView];

    // Create the header view
    NSBundle *bundle = TOFileKitBundleForObject(self);
    NSString *title = TOFileKitLocalized(@"FileLocationPicker.Intro.Title", bundle);
    NSString *message = TOFileKitLocalized(@"FileLocationPicker.Intro.Message", bundle);
    self.headerView = [[TOFileTableTitleHeaderView alloc] initWithTitle:title message:message];

    // Size the header view to align with the width of this view and set it to the table
    [self.headerView sizeToFitInWidth:self.frame.size.width];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setFrame:(CGRect)frame
{
    CGFloat oldWidth = self.frame.size.width;
    [super setFrame:frame];

    // If the width changed, relayout the header view
    if ((NSInteger)oldWidth != (NSInteger)frame.size.width) {
        self.tableView.tableHeaderView = nil;
        [self.headerView sizeToFitInWidth:frame.size.width];
        self.tableView.tableHeaderView = self.headerView;
    }
}

@end
