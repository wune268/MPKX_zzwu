//
//  WuMessageViewCell.h
//  MPKX
//
//  Created by zzwu on 15/12/8.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WuMessageFrame;

@interface WuMessageViewCell : UITableViewCell

@property (nonatomic, strong) WuMessageFrame *messageFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
