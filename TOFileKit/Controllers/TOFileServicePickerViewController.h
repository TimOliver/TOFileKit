//
//  ICServicePickerViewController.h
//  icomics
//
//  Created by Tim Oliver on 28/10/2015.
//  Copyright © 2015 Timothy Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TOFileServicePickerViewController : UITableViewController

@property (nonatomic, copy) void (^didAddNewAccountHandler)();

@end
