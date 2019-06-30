//
//  TOFileTableTitleHeaderView.h
//  TOFileKitExample
//
//  Created by Tim Oliver on 30/6/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A table view header view that displays a center-aligned
 title and message above all of the table rows
 */
@interface TOFileTableTitleHeaderView : UIView

/** The title text displayed in large sizing alongt the top */
@property (nonatomic, copy) NSString *title;

/** The message text displayed in standard sizing underneath the title */
@property (nonatomic, copy) NSString *message;

/** The color of the title text */
@property (nonatomic, strong) UIColor *titleColor;

/** The color of the message text */
@property (nonatomic, strong) UIColor *messageColor;

/** Create a new instance of the header view with the provided title and message */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
