//
//  WuUserItems.h
//  MPKX
//
//  Created by zzwu on 15/11/21.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WuItemOption)();

@interface WuUserItems : NSObject

/**
 * 图标
 */
@property(nonatomic, copy)NSString *icon;

/**
 * 文字
 */
@property(nonatomic, copy)NSString *title;

/**
 *  存储block操作
 */
@property(nonatomic,copy)WuItemOption option;

/**
 *   创建图片和文字cell
 */
+(instancetype) itemWithIcon:(NSString *)icon title:(NSString *)title;

/**
 *  创建文字ell
 */
+(instancetype) itemWithTitle:(NSString *)title;

@end
