//
//  WuUserTableViewCell.h
//  MPKX
//
//  Created by zzwu on 15/11/21.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WuUserItems;

@interface WuUserTableViewCell : UITableViewCell

/**
 *  模型数据
 */
@property (nonatomic, strong) WuUserItems *item;

/**
 *  创建cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
