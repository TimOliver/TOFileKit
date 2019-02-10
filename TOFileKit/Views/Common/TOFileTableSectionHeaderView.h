//
//  TOFileTableSectionHeaderView.h
//  TOFileKitExample
//
//  Created by Tim Oliver on 10/2/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TOFileTableSectionHeaderView : UITableViewHeaderFooterView

+ (CGFloat)height;

@property (nonatomic, readonly) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
